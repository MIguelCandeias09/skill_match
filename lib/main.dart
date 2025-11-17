import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SkillMatchApp());
}

class SkillMatchApp extends StatelessWidget {
  const SkillMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skill Match',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
