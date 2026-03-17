import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _zoomAnimation = Tween<double>(begin: 0.5, end: 1.15).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );
    _zoomController.forward();
    Timer(const Duration(milliseconds: 2200), _navigateAway);
  }

  void _navigateAway() {
    if (!mounted) return;
    final isLoggedIn = context.read<AuthProvider>().isLoggedIn;
    context.go(isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryDark,
              AppTheme.primary,
              AppTheme.primaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _zoomAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _zoomAnimation.value,
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
