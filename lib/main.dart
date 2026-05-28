import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'data/preferences.dart';
import 'screens/home/home_screen.dart';
import 'screens/intervention/intervention_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  // Must be called first
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize local storage
  await AppPreferences.initialize();

  // Run the app
  runApp(const MindGateApp());
}

class MindGateApp extends StatelessWidget {
  const MindGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Decide start screen: onboarding or home
    final startRoute =
        AppPreferences.onboardingComplete ? '/home' : '/onboarding';

    return MaterialApp(
      title: 'MindGate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: startRoute,
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/intervention': (context) => const InterventionScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
