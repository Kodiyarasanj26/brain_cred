import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/course_provider.dart';
import '../../../services/local_storage_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    super.key,
    required this.courseId,
    required this.lessonIndex,
  });

  final String courseId;
  final int lessonIndex;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  static const int _testDurationSeconds = 300; // 5 minutes
  int _currentQuestion = 0;
  List<int?> _selectedAnswers = [];
  int _secondsRemaining = _testDurationSeconds;
  Timer? _timer;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _startTest();
  }

  void _startTest() async {
    await Future.delayed(kSimulatedApiDelay);
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final userEmail = auth.currentUser?.email ?? '';
    final deducted = await LocalStorageService.deductWalletCredits(
      userEmail,
      AppConstants.testCreditsCost,
    );
    if (!deducted || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not enough credits for this test'),
            backgroundColor: AppTheme.error,
          ),
        );
        context.pop();
      }
      return;
    }
    auth.refreshUser();
    final course = context.read<CourseProvider>().getCourseById(widget.courseId);
    if (course != null && mounted) {
      setState(() {
        _selectedAnswers = List.filled(course.lessons[widget.lessonIndex].testQuestions.length, null);
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          if (_secondsRemaining <= 0) {
            _timer?.cancel();
            _submitTest();
          } else {
            _secondsRemaining--;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _submitTest() {
    if (_submitted) return;
    _submitted = true;
    _timer?.cancel();
    final auth = context.read<AuthProvider>();
    final userEmail = auth.currentUser?.email ?? '';
    LocalStorageService.incrementTestAttempt(userEmail, widget.courseId, widget.lessonIndex);
    final course = context.read<CourseProvider>().getCourseById(widget.courseId)!;
    final lesson = course.lessons[widget.lessonIndex];
    int correct = 0;
    for (var i = 0; i < lesson.testQuestions.length; i++) {
      if (_selectedAnswers[i] == lesson.testQuestions[i].correctIndex) correct++;
    }
    final total = lesson.testQuestions.length;
    final percent = total > 0 ? (correct * 100 / total).round() : 0;
    LocalStorageService.setBestScore(userEmail, widget.courseId, widget.lessonIndex, percent);
    if (context.mounted) {
      context.go('/test-result/${widget.courseId}/${widget.lessonIndex}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = context.watch<CourseProvider>().getCourseById(widget.courseId);
    if (course == null || widget.lessonIndex >= course.lessons.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test')),
        body: const Center(child: Text('Not found')),
      );
    }

    final lesson = course.lessons[widget.lessonIndex];
    final questions = lesson.testQuestions;
    if (_selectedAnswers.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: const AppLoadingIndicator(message: 'Loading test...'),
        ),
      );
    }

    final question = questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('Test: ${lesson.title}'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _secondsRemaining <= 60
                      ? AppTheme.error.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentQuestion + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Question ${_currentQuestion + 1} of ${questions.length}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(question.options.length, (i) {
                      final isSelected = _selectedAnswers[_currentQuestion] == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedAnswers[_currentQuestion] = i);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? AppTheme.primary.withValues(alpha: 0.08)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: isSelected
                                      ? AppTheme.primary
                                      : Colors.grey,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(question.options[i]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_currentQuestion > 0)
                    OutlinedButton(
                      onPressed: () =>
                          setState(() => _currentQuestion--),
                      child: const Text('Previous'),
                    ),
                  if (_currentQuestion > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_currentQuestion < questions.length - 1) {
                          setState(() => _currentQuestion++);
                        } else {
                          _submitTest();
                        }
                      },
                      child: Text(
                        _currentQuestion < questions.length - 1
                            ? 'Next'
                            : 'Submit Test',
                      ),
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
