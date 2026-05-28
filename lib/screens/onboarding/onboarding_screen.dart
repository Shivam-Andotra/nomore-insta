import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final _pages = const [
    {
      'icon': '🧠',
      'title': 'Welcome to MindGate',
      'desc': 'Your companion to break Instagram addiction.\n'
          'We create a moment of pause before you scroll.'
    },
    {
      'icon': '⏱️',
      'title': 'The Power of a Pause',
      'desc': 'When you open Instagram, MindGate shows a\n'
          'calming screen. Just 1 second breaks the habit.'
    },
    {
      'icon': '📊',
      'title': 'Track Your Growth',
      'desc': 'See your progress, build streaks, and watch\n'
          'your mindfulness score rise every day.'
    },
    {
      'icon': '🚀',
      'title': 'Ready to Start?',
      'desc': 'Enable protection and take control of\n'
          'your Instagram usage. You\'ve got this!'
    },
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      AppPreferences.setOnboardingComplete(true);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _skip() {
    AppPreferences.setOnboardingComplete(true);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: const Text('Skip',
                    style: TextStyle(color: AppColors.textSubtle)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_pages[i]['icon']!,
                          style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 32),
                      Text(_pages[i]['title']!,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(_pages[i]['desc']!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.6),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => Container(
                  width: _page == i ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        _page == i ? AppColors.primary : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _page == _pages.length - 1 ? 'Get Started 🚀' : 'Next →',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
