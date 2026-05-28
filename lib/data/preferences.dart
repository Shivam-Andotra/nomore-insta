import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Protection ON/OFF
  static bool get isEnabled => _prefs.getBool('is_enabled') ?? false;
  static Future<void> setEnabled(bool value) =>
      _prefs.setBool('is_enabled', value);

  // Delay Duration
  static int get delaySeconds => _prefs.getInt('delay_seconds') ?? 1;
  static Future<void> setDelaySeconds(int value) =>
      _prefs.setInt('delay_seconds', value);

  // Streak
  static int get streak => _prefs.getInt('streak') ?? 0;
  static Future<void> setStreak(int value) => _prefs.setInt('streak', value);
  static int get bestStreak => _prefs.getInt('best_streak') ?? 0;

  static Future<void> incrementStreak() async {
    int current = streak + 1;
    await _prefs.setInt('streak', current);
    if (current > bestStreak) {
      await _prefs.setInt('best_streak', current);
    }
  }

  static Future<void> resetStreak() async {
    await _prefs.setInt('streak', 0);
  }

  // Stats
  static int get totalInterceptions =>
      _prefs.getInt('total_interceptions') ?? 0;
  static int get totalChangedMind => _prefs.getInt('total_changed_mind') ?? 0;
  static int get totalProceeded => _prefs.getInt('total_proceeded') ?? 0;

  static Future<void> logInterception() async {
    await _prefs.setInt('total_interceptions', totalInterceptions + 1);
  }

  static int get totalSecondsSaved => _prefs.getInt('total_seconds_saved') ?? 0;
  static int get totalMinutesSaved => totalSecondsSaved ~/ 60;

  static Future<void> logChangedMind() async {
    await _prefs.setInt('total_changed_mind', totalChangedMind + 1);
    await _prefs.setInt('total_seconds_saved', totalSecondsSaved + delaySeconds);
    await incrementStreak();
  }

  static Future<void> logProceeded() async {
    await _prefs.setInt('total_proceeded', totalProceeded + 1);
    await resetStreak();
  }

  // Mindfulness Score
  static double get mindfulnessScore {
    int total = totalChangedMind + totalProceeded;
    if (total == 0) return 0;
    return (totalChangedMind / total) * 100;
  }

  // Onboarding
  static bool get onboardingComplete =>
      _prefs.getBool('onboarding_complete') ?? false;
  static Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool('onboarding_complete', value);

  // Reset
  static Future<void> resetAll() async {
    await _prefs.clear();
  }
}
