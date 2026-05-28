import 'package:flutter/material.dart';
import 'package:mindgate/core/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/preferences.dart';
import '../../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEnabled = false;
  int _delaySeconds = 1;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isEnabled = AppPreferences.isEnabled;
      _delaySeconds = AppPreferences.delaySeconds;
    });
  }

  void _toggleProtection(bool value) {
    AppPreferences.setEnabled(value);
    setState(() => _isEnabled = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            value ? '🛡️ MindGate Activate ho gaya!' : 'MindGate Band kar diya'),
        backgroundColor: value ? AppColors.success : AppColors.textMuted,
      ),
    );
  }

  void _updateDelay(double value) {
    int seconds = value
        .round()
        .clamp(Constants.minDelaySeconds, Constants.maxDelaySeconds);
    AppPreferences.setDelaySeconds(seconds);
    setState(() => _delaySeconds = seconds);
  }

  void _simulateInterception() {
    Navigator.of(context).pushNamed('/intervention');
  }

  String _formatTimeSaved(int minutes) {
    if (minutes < 1) return '< 1 min';
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  @override
  Widget build(BuildContext context) {
    final streak = AppPreferences.streak;
    final minutesSaved = AppPreferences.totalMinutesSaved;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Greeting + Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.getTimeGreeting(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSubtle,
                        ),
                      ),
                      const Text(
                        'MindGate 🧠',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        Constants.getMotivationalLevel(streak),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Time saved badge
                  if (minutesSaved > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text('⏱️ Saved',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSubtle)),
                          Text(
                            _formatTimeSaved(minutesSaved),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Protection toggle
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isEnabled
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isEnabled
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isEnabled
                            ? Icons.shield_rounded
                            : Icons.shield_outlined,
                        color: _isEnabled
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEnabled
                                ? 'Protection Active'
                                : 'Protection Band Hai',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _isEnabled
                                ? 'Focus guard kar raha hai 🛡️'
                                : 'Activate karo — shuru karo!',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isEnabled,
                      onChanged: _toggleProtection,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Delay slider
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('⏱️', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text(
                          'Pause Duration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Jitna lamba pause, utna zyaada sochne ka time',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.textSubtle),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: _delaySeconds.toDouble(),
                      min: Constants.minDelaySeconds.toDouble(),
                      max: Constants.maxDelaySeconds.toDouble(),
                      divisions: Constants.maxDelaySeconds - 1,
                      onChanged: _updateDelay,
                    ),
                    Center(
                      child: Text(
                        '$_delaySeconds second${_delaySeconds > 1 ? 's' : ''} ka pause',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('📊', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text(
                          'Tumhara Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StatCard(
                      icon: '🚫',
                      label: 'Total Interceptions',
                      value: '${AppPreferences.totalInterceptions}',
                    ),
                    const SizedBox(height: 8),
                    StatCard(
                      icon: '✅',
                      label: 'Mann Badla (Go Back)',
                      value: '${AppPreferences.totalChangedMind}',
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: 8),
                    StatCard(
                      icon: '📱',
                      label: 'Instagram Khola',
                      value: '${AppPreferences.totalProceeded}',
                      valueColor: AppColors.danger,
                    ),
                    const SizedBox(height: 8),
                    StatCard(
                      icon: '🎯',
                      label: 'Mindfulness Score',
                      value:
                          '${AppPreferences.mindfulnessScore.toStringAsFixed(0)}%',
                      valueColor: AppColors.accent,
                    ),
                    const SizedBox(height: 8),
                    StatCard(
                      icon: '🔥',
                      label: 'Current Streak',
                      value: '$streak',
                      valueColor: AppColors.accent,
                    ),
                    const SizedBox(height: 8),
                    StatCard(
                      icon: '⏱️',
                      label: 'Time Bachaya',
                      value: _formatTimeSaved(minutesSaved),
                      valueColor: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Test button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _simulateInterception,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Intervention Screen Test Karo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Settings button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/settings'),
                  icon: const Icon(Icons.settings_rounded,
                      color: AppColors.textSubtle),
                  label: const Text('Settings',
                      style: TextStyle(color: AppColors.textSubtle)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.surfaceLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
