import 'package:flutter/material.dart';
import 'core/utils/app_router.dart';
import 'shared/theme/app_theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bluu Superadmin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
