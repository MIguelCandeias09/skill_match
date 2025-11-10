import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/homepage_screen.dart';
import 'screens/create_offer_screen.dart';
import 'screens/map_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SkillMatchApp());
}

class SkillMatchApp extends StatelessWidget {
  const SkillMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Match',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/homepage': (context) => const HomepageScreen(),
        '/create_offer': (context) => const CreateOfferScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
