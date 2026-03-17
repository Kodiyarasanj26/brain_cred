import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  final authProvider = AuthProvider();
  await authProvider.init();
  runApp(BrainCredApp(authProvider: authProvider));
}

class BrainCredApp extends StatelessWidget {
  const BrainCredApp({super.key, required this.authProvider});
  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<CourseProvider>(create: (_) => CourseProvider()),
      ],
      child: MaterialApp.router(
        title: 'Brain Cred',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: createAppRouter(authProvider),
      ),
    );
  }
}
