import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';

class AppSidebar extends StatelessWidget {
  final String activeRoute;

  const AppSidebar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppTheme.sidebarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2D3F55), width: 1),
              ),
            ),
            child: const Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Navigation items
          _SidebarItem(
            label: 'Dashboard',
            route: '/dashboard',
            activeRoute: activeRoute,
          ),
          _SidebarItem(
            label: 'Products',
            route: '/dashboard/products',
            activeRoute: activeRoute,
          ),

          const Spacer(),

          // Logout
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF2D3F55), width: 1),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFC8181),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final String route;
  final String activeRoute;

  const _SidebarItem({
    required this.label,
    required this.route,
    required this.activeRoute,
  });

  bool get _isActive =>
      activeRoute == route ||
      (route != '/dashboard' && activeRoute.startsWith(route));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: _isActive ? AppTheme.sidebarActiveColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () => context.go(route),
        style: TextButton.styleFrom(
          foregroundColor: _isActive ? Colors.white : const Color(0xFFADB5C7),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.centerLeft,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
