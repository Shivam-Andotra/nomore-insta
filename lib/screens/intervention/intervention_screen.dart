import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Cycling content card
  int _activeTab = 0; // 0=calm, 1=quote, 2=suggestion, 3=fact
  late String _calmMessage;
  late Map<String, String> _quote;
  late String _suggestion;
  late String _fact;

  // Breathing guide
  bool _breatheIn = true;
  Timer? _breathTimer;

  @override
  void initState() {
    super.initState();
    _totalTime = AppPreferences.delaySeconds.toDouble();
    _timeRemaining = _totalTime;

    _calmMessage = Constants.calmMessages[
        DateTime.now().millisecondsSinceEpoch % Constants.calmMessages.length];
    _quote = Constants.randomQuote();
    _suggestion = Constants.randomDoThisInstead();
    _fact = Constants.randomFact();

    AppPreferences.logInterception();
    _startTimer();
    _startBreathTimer();
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

  void _startBreathTimer() {
    _breathTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() => _breatheIn = !_breatheIn);
    });
  }

  void _cycleContent() {
    HapticFeedback.lightImpact();
    setState(() => _activeTab = (_activeTab + 1) % 4);
  }

  void _onChangedMind() {
    AppPreferences.logChangedMind();
    Navigator.of(context).pushReplacementNamed('/home');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💪 Shabash! Willpower grows stronger!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onProceed() {
    AppPreferences.logProceeded();
    Navigator.of(context).pushReplacementNamed('/home');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📱 Thoda dhyan rakhna Instagram pe!'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathTimer?.cancel();
    super.dispose();
  }

  Widget _buildContentCard() {
    final tabs = [
      {'icon': '💭', 'label': 'Soch'},
      {'icon': '✨', 'label': 'Quote'},
      {'icon': '🎯', 'label': 'Karo'},
      {'icon': '📊', 'label': 'Fact'},
    ];

    Widget content;
    switch (_activeTab) {
      case 1:
        content = Column(
          children: [
            Text(
              _quote['quote']!,
              style: const TextStyle(
                  fontSize: 17, color: AppColors.textPrimary, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _quote['author']!,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.accent,
                  fontStyle: FontStyle.italic),
            ),
          ],
        );
        break;
      case 2:
        content = Column(
          children: [
            const Text('Ye karo instead:',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSubtle,
                    letterSpacing: 0.5)),
            const SizedBox(height: 10),
            Text(
              _suggestion,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        );
        break;
      case 3:
        content = Column(
          children: [
            const Text('Kya tum jaante ho?',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSubtle,
                    letterSpacing: 0.5)),
            const SizedBox(height: 10),
            Text(
              _fact,
              style: const TextStyle(
                  fontSize: 17, color: AppColors.textPrimary, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        );
        break;
      default:
        content = Text(
          _calmMessage,
          style: const TextStyle(
              fontSize: 17, color: AppColors.textPrimary, height: 1.6),
          textAlign: TextAlign.center,
        );
    }

    return GestureDetector(
      onTap: _cycleContent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            // Tab indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final isActive = i == _activeTab;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.surfaceLight,
                    ),
                  ),
                  child: Text(
                    '${tabs[i]['icon']} ${tabs[i]['label']}',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          isActive ? AppColors.primary : AppColors.textMuted,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app_rounded,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  'Tap to explore',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        _totalTime > 0 ? (1 - (_timeRemaining / _totalTime)) : 1.0;
    final streak = AppPreferences.streak;
    final milestone = Constants.getStreakCelebration(streak);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
          child: Column(
            children: [
              // Breathing circle + guide
              const BreathingCircle(
                size: 120,
                child: Text('🧠', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  _breatheIn ? 'Saans lo... 🌬️' : 'Choddo... 😮‍💨',
                  key: ValueKey(_breatheIn),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              const Text(
                'MindGate',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'Ruko. Socho. Decide karo.',
                style: TextStyle(fontSize: 13, color: AppColors.textSubtle),
              ),
              const SizedBox(height: 20),

              // Streak milestone banner
              if (milestone.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    milestone,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Cycling content card
              _buildContentCard(),
              const SizedBox(height: 20),

              // Timer
              Text(
                _canProceed
                    ? '✅ Ab proceed kar sakte ho ya wapas jao'
                    : '⏳ ${_timeRemaining.toStringAsFixed(1)} seconds baaqi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _canProceed ? AppColors.success : AppColors.accent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

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
              const SizedBox(height: 10),

              // Streak
              Text(
                '🔥 Mindful Streak: $streak',
                style: const TextStyle(
                    fontSize: 14, color: AppColors.accent),
              ),
              const SizedBox(height: 24),

              // Go Back button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onChangedMind,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    '🚪 Mann badal gaya — Wapas Jao!',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Proceed button
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
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Instagram pe jaana hai...',
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
