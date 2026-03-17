import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../models/course_model.dart';
import '../../../models/notification_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/course_provider.dart';
import '../../../services/local_storage_service.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.courseId});
  final String courseId;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool _isUnlocking = false;

  @override
  Widget build(BuildContext context) {
    final course = context.watch<CourseProvider>().getCourseById(widget.courseId);
    final auth = context.watch<AuthProvider>();
    final userEmail = auth.currentUser?.email ?? '';
    final isUnlocked = LocalStorageService.getUnlockedCourseIds(userEmail).contains(widget.courseId);
    final credits = auth.walletCredits;

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: const Center(child: Text('Course not found')),
      );
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(course.title),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.library_books_rounded,
                              size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(
                            '${course.lessons.length} lessons',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${course.creditCost} credits',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!isUnlocked) ...[
                const SizedBox(height: 20),
                Center(
                  child: FilledButton.icon(
                    onPressed: credits >= course.creditCost && !_isUnlocking
                        ? () => _unlockAndContinue(context, course, userEmail)
                        : null,
                    icon: _isUnlocking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.lock_open_rounded),
                    label: Text(
                      _isUnlocking ? 'Unlocking...' : 'Unlock for ${course.creditCost} credits',
                    ),
                  ),
                ),
                if (credits < course.creditCost)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'You need ${course.creditCost - credits} more credits',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              Text(
                'Lessons',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ...List.generate(course.lessons.length, (i) {
                final lesson = course.lessons[i];
                final completed = LocalStorageService.isLessonCompleted(
                    userEmail, widget.courseId, i);
                final attemptCount = LocalStorageService.getTestAttemptCount(
                    userEmail, widget.courseId, i);
                final isLastLesson = i == course.lessons.length - 1;
                final hasQuestions = lesson.testQuestions.isNotEmpty;
                final canTakeTest = isUnlocked && attemptCount < 1 && isLastLesson && hasQuestions;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: completed
                              ? AppTheme.success.withValues(alpha: 0.2)
                              : AppTheme.primary.withValues(alpha: 0.2),
                          child: Icon(
                            completed ? Icons.check_rounded : Icons.menu_book_rounded,
                            color: completed ? AppTheme.success : AppTheme.primary,
                          ),
                        ),
                        title: Text(lesson.title),
                        subtitle: Text(
                          completed ? 'Completed' : 'Tap to read',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: isUnlocked
                            ? () => context.push(
                                '/lesson/${widget.courseId}/$i',
                              )
                            : null,
                      ),
                        if (isUnlocked && hasQuestions)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: canTakeTest &&
                                      auth.walletCredits >=
                                          AppConstants.testCreditsCost
                                  ? () => _startTest(context, widget.courseId, i)
                                  : null,
                              icon: const Icon(Icons.quiz_rounded, size: 20),
                              label: Text(
                                attemptCount >= 1
                                    ? 'Test attempted'
                                    : 'Take Test (${AppConstants.testCreditsCost} credits)',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
        ),
        if (_isUnlocking)
          const Positioned.fill(
            child: AppLoadingOverlay(message: 'Unlocking course...'),
          ),
      ],
    );
  }

  Future<void> _unlockAndContinue(
    BuildContext context,
    CourseModel course,
    String userEmail,
  ) async {
    setState(() => _isUnlocking = true);
    await Future.delayed(kSimulatedApiDelay);
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final ok = await LocalStorageService.deductWalletCredits(
      userEmail,
      course.creditCost,
    );
    if (!ok || !mounted) {
      setState(() => _isUnlocking = false);
      return;
    }
    await LocalStorageService.addUnlockedCourse(userEmail, course.id);
    await LocalStorageService.addNotification(
      userEmail,
      NotificationModel(
        id: const Uuid().v4(),
        title: 'Course unlocked',
        body: 'You unlocked "${course.title}". Start learning now!',
        createdAt: DateTime.now(),
        type: 'course_unlocked',
      ),
    );
    auth.refreshUser();
    if (!mounted) return;
    setState(() => _isUnlocking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unlocked: ${course.title}'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _startTest(BuildContext context, String courseId, int lessonIndex) {
    context.push('/test/$courseId/$lessonIndex');
  }
}
