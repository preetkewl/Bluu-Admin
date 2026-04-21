import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/products/presentation/screens/dashboard_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/products/domain/entities/product_entity.dart';
import '../../features/products/presentation/bloc/products_bloc.dart';
import 'constants.dart';
import 'service_locator.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Shared AuthBloc instance kept alive across dashboard routes so logout
/// state is preserved during navigation between dashboard pages.
AuthBloc? _authBlocInstance;

AuthBloc _getOrCreateAuthBloc() {
  if (_authBlocInstance == null || _authBlocInstance!.isClosed) {
    _authBlocInstance = sl<AuthBloc>();
  }
  return _authBlocInstance!;
}

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.authTokenKey);
      final isLoggedIn = token != null && token.isNotEmpty;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/dashboard/products';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => BlocProvider<AuthBloc>.value(
          value: _getOrCreateAuthBloc(),
          child: _WithLogoutRedirect(child: const DashboardScreen()),
        ),
        routes: [
          GoRoute(
            path: 'products',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>.value(
                  value: _getOrCreateAuthBloc(),
                ),
                BlocProvider<ProductsBloc>(
                  create: (_) => sl<ProductsBloc>(),
                ),
              ],
              child: _WithLogoutRedirect(child: const ProductsScreen()),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final product = state.extra as ProductEntity;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<AuthBloc>.value(
                        value: _getOrCreateAuthBloc(),
                      ),
                      BlocProvider<ProductsBloc>(
                        create: (_) => sl<ProductsBloc>(),
                      ),
                    ],
                    child: _WithLogoutRedirect(
                      child: ProductDetailScreen(product: product),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _WithLogoutRedirect extends StatelessWidget {
  final Widget child;

  const _WithLogoutRedirect({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          _authBlocInstance = null;
          context.go('/login');
        }
      },
      child: child,
    );
  }
}
