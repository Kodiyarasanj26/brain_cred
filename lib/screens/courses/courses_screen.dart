import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/course_model.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/course_provider.dart';
import '../../../services/local_storage_service.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    context.read<CourseProvider>().loadCourses();
    await Future.delayed(kSimulatedApiDelay);
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: SafeArea(
          child: const AppLoadingIndicator(message: 'Loading courses...'),
        ),
      );
    }
    final courses = context.watch<CourseProvider>().courses;
    final auth = context.watch<AuthProvider>();
    final userEmail = auth.currentUser?.email ?? '';
    final unlocked = LocalStorageService.getUnlockedCourseIds(userEmail);
    final credits = auth.walletCredits;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Courses',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unlock with credits • ${courses.length} available',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final course = courses[index];
                  final isUnlocked = unlocked.contains(course.id);
                  final canAfford = credits >= course.creditCost;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: _CourseCard(
                      course: course,
                      isUnlocked: isUnlocked,
                      canAfford: canAfford,
                      credits: credits,
                      onTap: () => context.push('/course/${course.id}'),
                    ),
                  );
                },
                childCount: courses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
    required this.isUnlocked,
    required this.canAfford,
    required this.credits,
    required this.onTap,
  });

  final CourseModel course;
  final bool isUnlocked;
  final bool canAfford;
  final int credits;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.library_books_rounded, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${course.lessons.length} lessons',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppTheme.success.withValues(alpha: 0.15)
                          : AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUnlocked ? Icons.check_circle_rounded : Icons.star_rounded,
                          size: 16,
                          color: isUnlocked ? AppTheme.success : AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isUnlocked ? 'Unlocked' : '${course.creditCost} credits',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isUnlocked ? AppTheme.success : AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
