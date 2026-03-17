import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/notification_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/local_storage_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final userEmail = context.read<AuthProvider>().currentUser?.email ?? '';
    setState(() {
      _notifications = LocalStorageService.getNotifications(userEmail);
    });
  }

  Future<void> _markAllRead() async {
    final userEmail = context.read<AuthProvider>().currentUser?.email ?? '';
    await LocalStorageService.markAllNotificationsRead(userEmail);
    _loadNotifications();
  }

  Future<void> _clearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text(
          'This will remove all notifications. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final userEmail = context.read<AuthProvider>().currentUser?.email ?? '';
    await LocalStorageService.clearAllNotifications(userEmail);
    if (mounted) _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.read).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_notifications.isNotEmpty) ...[
            if (unreadCount > 0)
              TextButton.icon(
                onPressed: _markAllRead,
                icon: const Icon(Icons.done_all_rounded, size: 20, color: Colors.white),
                label: const Text('Mark all read'),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              onSelected: (value) {
                if (value == 'clear') _clearAll();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded),
                      SizedBox(width: 8),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your updates will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _NotificationTile(
                    notification: notification,
                    onTap: () async {
                      final userEmail = context.read<AuthProvider>().currentUser?.email ?? '';
                      if (!notification.read) {
                        await LocalStorageService.markNotificationRead(userEmail, notification.id);
                        if (mounted) _loadNotifications();
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, h:mm a').format(notification.createdAt);
    final icon = _iconForType(notification.type);

    return Material(
      color: notification.read ? null : AppTheme.primary.withValues(alpha: 0.05),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: icon.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon.icon, size: 24, color: icon.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.read ? FontWeight.w500 : FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.read)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 8, top: 6),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  ({IconData icon, Color color}) _iconForType(String type) {
    switch (type) {
      case 'welcome':
        return (icon: Icons.celebration_rounded, color: AppTheme.primary);
      case 'course_unlocked':
        return (icon: Icons.lock_open_rounded, color: AppTheme.success);
      case 'test_passed':
        return (icon: Icons.quiz_rounded, color: AppTheme.success);
      case 'certificate':
        return (icon: Icons.workspace_premium_rounded, color: AppTheme.warning);
      default:
        return (icon: Icons.notifications_rounded, color: AppTheme.primary);
    }
  }
}
