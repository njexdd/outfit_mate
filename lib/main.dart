import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/user_prefs.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'data/database/app_database.dart';

late AppDatabase db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  db = AppDatabase();
  await UserPrefs.init();

  final showOnboarding = !UserPrefs.isOnboardingComplete;

  runApp(OutfitApp(showOnboarding: showOnboarding));
}

class OutfitApp extends StatelessWidget {
  final bool showOnboarding;
  const OutfitApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OutfitMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: showOnboarding
          ? const OnboardingScreen()
          : const MainNavigationScreen(),
    );
  }
}
