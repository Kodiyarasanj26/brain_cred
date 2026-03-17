import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/main_shell/main_shell_screen.dart';
import '../../screens/course/course_detail_screen.dart';
import '../../screens/lesson/lesson_content_screen.dart';
import '../../screens/test/test_screen.dart';
import '../../screens/test/test_result_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/my_certificates_screen.dart';
import '../../screens/notifications/notifications_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final isSplash = state.matchedLocation == '/splash';
      final isAuth = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (isSplash) return null;
      if (!isLoggedIn && !isAuth) return '/login';
      if (isLoggedIn && isAuth) return '/home'; // tab is optional: ?tab=wallet etc.
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final fromSignup = state.uri.queryParameters['from'] == 'signup';
          return LoginScreen(fromSignup: fromSignup);
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          return MainShellScreen(initialTab: tab);
        },
      ),
      GoRoute(
        path: '/course/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CourseDetailScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/lesson/:courseId/:lessonIndex',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final index = int.parse(state.pathParameters['lessonIndex']!);
          return LessonContentScreen(courseId: courseId, lessonIndex: index);
        },
      ),
      GoRoute(
        path: '/test/:courseId/:lessonIndex',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final index = int.parse(state.pathParameters['lessonIndex']!);
          return TestScreen(courseId: courseId, lessonIndex: index);
        },
      ),
      GoRoute(
        path: '/test-result/:courseId/:lessonIndex',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final index = int.parse(state.pathParameters['lessonIndex']!);
          return TestResultScreen(courseId: courseId, lessonIndex: index);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/my-certificates',
        builder: (_, __) => const MyCertificatesScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
    ],
  );
}
