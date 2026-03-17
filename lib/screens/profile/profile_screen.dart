import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/profile_image_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        _ProfileAvatar(
                          userEmail: user?.email ?? '',
                          userName: user?.name ?? '?',
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'User',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? '',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _ProfileCardTile(
                      icon: Icons.edit_rounded,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _ProfileCardTile(
                      icon: Icons.school_rounded,
                      title: 'Course Completion',
                      subtitle: 'View your progress',
                      onTap: () => context.go('/home?tab=courses'),
                    ),
                    _ProfileCardTile(
                      icon: Icons.workspace_premium_rounded,
                      title: 'My Certificates',
                      subtitle: 'Download your certificates',
                      onTap: () => context.push('/my-certificates'),
                    ),
                    _ProfileCardTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out of your account',
                      onTap: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                              'Are you sure you want to sign out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.error,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                        if (ok == true && context.mounted) {
                          await context.read<AuthProvider>().logout();
                          if (context.mounted) context.go('/login');
                        }
                      },
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCardTile extends StatelessWidget {
  const _ProfileCardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.error : AppTheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppTheme.error : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.userEmail, required this.userName});
  final String userEmail;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final path = ProfileImageService.getProfileImagePath(userEmail);
    final hasImage = path != null && File(path).existsSync();

    return CircleAvatar(
      radius: 36,
      backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
      backgroundImage: hasImage ? FileImage(File(path)) : null,
      child: hasImage
          ? null
          : Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
    );
  }
}
