import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mindgate/core/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/preferences.dart';
import '../../widgets/breathing_circle.dart';

class InterventionScreen extends StatefulWidget {
  const InterventionScreen({super.key});

  @override
  State<InterventionScreen> createState() => _InterventionScreenState();
}

class _InterventionScreenState extends State<InterventionScreen> {
  late double _timeRemaining;
  late double _totalTime;
  bool _canProceed = false;
  Timer? _timer;
  late String _calmMessage;

  @override
  void initState() {
    super.initState();
    _totalTime = AppPreferences.delaySeconds.toDouble();
    _timeRemaining = _totalTime;

    final random = Random();
    _calmMessage =
        Constants.calmMessages[random.nextInt(Constants.calmMessages.length)];

    AppPreferences.logInterception();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _timeRemaining -= 0.1;
        if (_timeRemaining <= 0) {
          _timeRemaining = 0;
          _canProceed = true;
          timer.cancel();
        }
      });
    });
  }

  void _onChangedMind() {
    AppPreferences.logChangedMind();
    Navigator.of(context).pushReplacementNamed('/home');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💪 Great choice! Your willpower grows stronger!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onProceed() {
    AppPreferences.logProceeded();
    Navigator.of(context).pushReplacementNamed('/home');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📱 Be mindful of your time on Instagram'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        _totalTime > 0 ? (1 - (_timeRemaining / _totalTime)) : 1.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Breathing brain icon
              const BreathingCircle(
                size: 140,
                child: Text('🧠', style: TextStyle(fontSize: 56)),
              ),
              const SizedBox(height: 20),

              // App name
              const Text(
                'MindGate',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Wait. Breathe. Reconsider.',
                style: TextStyle(fontSize: 14, color: AppColors.textSubtle),
              ),
              const SizedBox(height: 32),

              // Calm message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.info.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  _calmMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // Timer text
              Text(
                _canProceed
                    ? '✅ You can now proceed or go back'
                    : '⏳ ${_timeRemaining.toStringAsFixed(1)} seconds remaining',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _canProceed ? AppColors.success : AppColors.accent,
                ),
              ),
              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _canProceed ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Streak
              Text(
                '🔥 Mindful Streak: ${AppPreferences.streak}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.accent,
                ),
              ),

              const Spacer(flex: 2),

              // GO BACK button (always active)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onChangedMind,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '🚪 I Changed My Mind - Go Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // PROCEED button (active after timer)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _canProceed ? _onProceed : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textMuted,
                    side: BorderSide(
                      color: _canProceed
                          ? AppColors.surfaceLight
                          : Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue to Instagram...',
                    style: TextStyle(
                      fontSize: 14,
                      color: _canProceed
                          ? AppColors.textMuted
                          : AppColors.textMuted.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
