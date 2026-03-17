import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../providers/course_provider.dart';
import '../../../services/local_storage_service.dart';
import '../../../providers/auth_provider.dart';

class LessonContentScreen extends StatefulWidget {
  const LessonContentScreen({
    super.key,
    required this.courseId,
    required this.lessonIndex,
  });

  final String courseId;
  final int lessonIndex;

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final course = context.watch<CourseProvider>().getCourseById(widget.courseId);
    final userEmail = context.watch<AuthProvider>().currentUser?.email ?? '';

    if (course == null || widget.lessonIndex >= course.lessons.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final lesson = course.lessons[widget.lessonIndex];
    final completed = LocalStorageService.isLessonCompleted(
      userEmail,
      widget.courseId,
      widget.lessonIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (completed)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                avatar: const Icon(Icons.check_rounded, color: AppTheme.success, size: 18),
                label: const Text('Completed'),
                backgroundColor: AppTheme.success.withValues(alpha: 0.15),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          lesson.content,
                          style: const TextStyle(
                            height: 1.6,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saving
                          ? null
                          : () async {
                              setState(() => _saving = true);
                              await Future.delayed(kSimulatedShortDelay);
                              await LocalStorageService.setLessonCompleted(
                                userEmail,
                                widget.courseId,
                                widget.lessonIndex,
                              );
                              if (!context.mounted) return;
                              setState(() => _saving = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Progress saved'),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                              context.pop();
                            },
                      icon: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(completed ? Icons.check_rounded : Icons.done_all_rounded),
                      label: Text(completed && !_saving ? 'Marked complete' : _saving ? 'Saving...' : 'Mark complete'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
