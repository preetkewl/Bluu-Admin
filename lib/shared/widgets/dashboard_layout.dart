import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import 'app_sidebar.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;
  final String activeRoute;
  final String pageTitle;

  const DashboardLayout({
    super.key,
    required this.child,
    required this.activeRoute,
    required this.pageTitle,
  });

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _sidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 900;

    // Auto-collapse on small screens
    if (isSmallScreen && _sidebarExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _sidebarExpanded = false);
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: Row(
        children: [
          // Sidebar
          if (!isSmallScreen || _sidebarExpanded) ...[
            AppSidebar(activeRoute: widget.activeRoute),
          ],

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                _TopBar(
                  pageTitle: widget.pageTitle,
                  isSidebarExpanded: _sidebarExpanded,
                  isSmallScreen: isSmallScreen,
                  onToggleSidebar: () {
                    setState(() => _sidebarExpanded = !_sidebarExpanded);
                  },
                ),

                // Page content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String pageTitle;
  final bool isSidebarExpanded;
  final bool isSmallScreen;
  final VoidCallback onToggleSidebar;

  const _TopBar({
    required this.pageTitle,
    required this.isSidebarExpanded,
    required this.isSmallScreen,
    required this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppTheme.cardWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (isSmallScreen)
            TextButton(
              onPressed: onToggleSidebar,
              child: Text(
                isSidebarExpanded ? 'Close Menu' : 'Menu',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (isSmallScreen) const SizedBox(width: 8),
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.dangerColor,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
