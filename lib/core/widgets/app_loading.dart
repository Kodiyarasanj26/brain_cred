import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Simulated API delay for consistent loading UX (no real API).
const Duration kSimulatedApiDelay = Duration(milliseconds: 600);
const Duration kSimulatedShortDelay = Duration(milliseconds: 300);

/// Full-screen loading overlay with optional message (e.g. during "API call").
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message = 'Loading...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.primary),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline loading indicator for lists/sections.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
