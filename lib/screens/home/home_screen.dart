import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/course_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/course_provider.dart';
import '../../../services/local_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCreditsPopupIfNeeded());
    context.read<CourseProvider>().loadCourses();
  }

  void _showCreditsPopupIfNeeded() {
    final auth = context.read<AuthProvider>();
    if (!auth.shouldShowWelcomeCreditsPopup) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.celebration_rounded, color: AppTheme.primary, size: 28),
            SizedBox(width: 8),
            Text('Welcome!'),
          ],
        ),
        content: Text(
          'You have received ${AppConstants.welcomeCredits} credits in your wallet. Use them to unlock courses and take tests!',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              auth.markWelcomeCreditsShown();
              Navigator.of(ctx).pop();
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${context.watch<AuthProvider>().currentUser?.name ?? 'Learner'}!',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Continue your learning journey',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _NotificationIcon(
                      userEmail: context.watch<AuthProvider>().currentUser?.email ?? '',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 0,
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () => context.go('/home?tab=wallet'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: AppTheme.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Credits',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${context.watch<AuthProvider>().walletCredits}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
                SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick actions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home?tab=courses'),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _QuickActionCard(
                    icon: Icons.menu_book_rounded,
                    label: 'Browse Courses',
                    onTap: () => context.go('/home?tab=courses'),
                  ),
                  _QuickActionCard(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Wallet',
                    onTap: () => context.go('/home?tab=wallet'),
                  ),
                  _QuickActionCard(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    onTap: () => context.go('/home?tab=profile'),
                  ),
                  _QuickActionCard(
                    icon: Icons.workspace_premium_rounded,
                    label: 'Certificates',
                    onTap: () => context.push('/my-certificates'),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Explore courses',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home?tab=courses'),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _CourseSlider(
                courses: context.watch<CourseProvider>().courses,
                userEmail: context.watch<AuthProvider>().currentUser?.email ?? '',
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _CourseSlider extends StatelessWidget {
  const _CourseSlider({
    required this.courses,
    required this.userEmail,
  });

  final List<CourseModel> courses;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        clipBehavior: Clip.none,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final isUnlocked = LocalStorageService.getUnlockedCourseIds(userEmail).contains(course.id);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _CourseSliderCard(
              course: course,
              isUnlocked: isUnlocked,
              onTap: () => context.push('/course/${course.id}'),
            ),
          );
        },
      ),
    );
  }
}

class _CourseSliderCard extends StatelessWidget {
  const _CourseSliderCard({
    required this.course,
    required this.isUnlocked,
    required this.onTap,
  });

  final CourseModel course;
  final bool isUnlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary.withValues(alpha: 0.15),
                AppTheme.primaryLight.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: AppTheme.primary,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    if (isUnlocked)
                      Icon(Icons.lock_open_rounded, size: 20, color: AppTheme.success)
                    else
                      Text(
                        '${course.creditCost}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    if (!isUnlocked) ...[
                      const SizedBox(width: 2),
                      Text(
                        'credits',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${course.lessons.length} lessons',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
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

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.userEmail});
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    final unreadCount = LocalStorageService.getUnreadNotificationCount(userEmail);

    return IconButton(
      onPressed: () => context.push('/notifications'),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 28,
            color: const Color(0xFF1E293B),
          ),
          if (unreadCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: const BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: AppTheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
