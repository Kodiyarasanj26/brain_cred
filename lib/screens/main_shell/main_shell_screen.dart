import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../courses/courses_screen.dart';
import '../wallet/wallet_screen.dart';
import '../profile/profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    this.initialTab,
  });

  /// Optional tab name: dashboard, courses, wallet, profile
  final String? initialTab;

  static int _tabFromName(String? name) {
    switch (name?.toLowerCase()) {
      case 'courses':
        return 1;
      case 'wallet':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }

  static String _nameFromIndex(int index) {
    switch (index) {
      case 1:
        return 'courses';
      case 2:
        return 'wallet';
      case 3:
        return 'profile';
      default:
        return 'dashboard';
    }
  }

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  static const List<Widget> _screens = [
    HomeScreen(),
    CoursesScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = MainShellScreen._tabFromName(widget.initialTab);
  }

  @override
  void didUpdateWidget(MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentIndex = MainShellScreen._tabFromName(widget.initialTab);
    }
  }

  void _onTabTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    context.go('/home?tab=${MainShellScreen._nameFromIndex(index)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: _currentIndex == 0,
                  onTap: () => _onTabTap(0),
                ),
                _NavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Courses',
                  isSelected: _currentIndex == 1,
                  onTap: () => _onTabTap(1),
                ),
                _NavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Wallet',
                  isSelected: _currentIndex == 2,
                  onTap: () => _onTabTap(2),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: _currentIndex == 3,
                  onTap: () => _onTabTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppTheme.primary : const Color(0xFF64748B),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
