import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/certificate_model.dart';
import '../../../models/notification_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/course_provider.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../services/local_storage_service.dart';

class TestResultScreen extends StatefulWidget {
  const TestResultScreen({
    super.key,
    required this.courseId,
    required this.lessonIndex,
  });

  final String courseId;
  final int lessonIndex;

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  static String _grade(int score) {
    if (score >= 90) return 'Distinction';
    if (score >= 80) return 'First Class';
    if (score >= 70) return 'Second Class';
    return 'Pass';
  }

  CertificateModel? _certificate;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _saveCertificateIfPassed());
  }

  Future<void> _saveCertificateIfPassed() async {
    final course = context.read<CourseProvider>().getCourseById(widget.courseId);
    final user = context.read<AuthProvider>().currentUser;
    if (course == null || user == null || widget.lessonIndex >= course.lessons.length) return;
    final score = LocalStorageService.getBestScore(user.email, widget.courseId, widget.lessonIndex) ?? 0;
    if (score < AppConstants.passingScorePercent) return;
    final existing = LocalStorageService.getCertificates(user.email);
    if (existing.any((c) => c.courseId == widget.courseId && c.lessonTitle == course.lessons[widget.lessonIndex].title)) return;
    final cert = CertificateModel(
      id: const Uuid().v4(),
      userId: user.email,
      userEmail: user.email,
      userName: user.name,
      courseId: course.id,
      courseTitle: course.title,
      lessonTitle: course.lessons[widget.lessonIndex].title,
      scorePercent: score,
      grade: _grade(score),
      issuedAt: DateTime.now(),
    );
    await LocalStorageService.addCertificate(cert);
    final lessonTitle = course.lessons[widget.lessonIndex].title;
    final gradeStr = _grade(score);
    await LocalStorageService.addNotification(
      user.email,
      NotificationModel(
        id: const Uuid().v4(),
        title: 'Certificate earned!',
        body: 'You passed "$lessonTitle" with $score% ($gradeStr). Download your certificate from Profile.',
        createdAt: DateTime.now(),
        type: 'certificate',
      ),
    );
    // Reward credits for completing the course test (last lesson)
    final isLastLesson = widget.lessonIndex == course.lessons.length - 1;
    if (isLastLesson) {
      final earnedCredits = ((course.creditCost * 80) / 100).round(); // 80% of course credits
      await LocalStorageService.addWalletCredits(user.email, earnedCredits);
      if (mounted) {
        context.read<AuthProvider>().refreshUser();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You earned $earnedCredits credits for completing this course test!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
    if (mounted) setState(() => _certificate = cert);
  }

  @override
  Widget build(BuildContext context) {
    final course = context.watch<CourseProvider>().getCourseById(widget.courseId);
    final user = context.watch<AuthProvider>().currentUser;
    if (course == null || user == null || widget.lessonIndex >= course.lessons.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: const Center(child: Text('Not found')),
      );
    }

    final lesson = course.lessons[widget.lessonIndex];
    final score = LocalStorageService.getBestScore(user.email, widget.courseId, widget.lessonIndex) ?? 0;
    final passed = score >= AppConstants.passingScorePercent;
    final grade = _grade(score);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Result'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                passed ? Icons.celebration_rounded : Icons.info_rounded,
                size: 80,
                color: passed ? AppTheme.success : AppTheme.warning,
              ),
              const SizedBox(height: 16),
              Text(
                passed ? 'Congratulations!' : 'Test Complete',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored $score%',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: passed
                      ? AppTheme.success.withValues(alpha: 0.15)
                      : AppTheme.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  grade,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: passed ? AppTheme.success : AppTheme.warning,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _Row('Course', course.title),
                      _Row('Lesson', lesson.title),
                      _Row('Score', '$score%'),
                      _Row('Grade', grade),
                      _Row('Status', passed ? 'Passed' : 'Did not pass'),
                    ],
                  ),
                ),
              ),
              if (passed) ...[
                const SizedBox(height: 24),
                const Text(
                  'You have earned a certificate for this lesson.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isDownloading
                      ? null
                      : () async {
                          setState(() => _isDownloading = true);
                          await Future.delayed(kSimulatedShortDelay);
                          if (!mounted) return;
                          // Ensure the certificate is saved (and avoid duplicates) before opening preview.
                          await _saveCertificateIfPassed();
                          if (!mounted) return;
                          final certs = LocalStorageService.getCertificates(user.email);
                          final cert = certs.firstWhere(
                            (c) =>
                                c.courseId == course.id && c.lessonTitle == lesson.title,
                            orElse: () => _certificate ??
                                CertificateModel(
                                  id: const Uuid().v4(),
                                  userId: user.email,
                                  userEmail: user.email,
                                  userName: user.name,
                                  courseId: course.id,
                                  courseTitle: course.title,
                                  lessonTitle: lesson.title,
                                  scorePercent: score,
                                  grade: grade,
                                  issuedAt: DateTime.now(),
                                ),
                          );

                          setState(() => _isDownloading = false);
                          context.push(
                            '/certificate-preview',
                            extra: cert,
                          );
                        },
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.download_rounded),
                  label: Text(_isDownloading ? 'Generating PDF...' : 'Download Certificate (PDF)'),
                ),
              ],
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  context.go('/course/${widget.courseId}');
                },
                child: const Text('Back to Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
