import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _resetStats() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will delete all your stats and streaks. '
          'This cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              AppPreferences.resetAll();
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been reset'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            child:
                const Text('Reset', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: AppColors.textSubtle, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('⚙️ Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text('🧠', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 8),
                  Text('MindGate',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  Text('Version 1.0.0',
                      style:
                          TextStyle(color: AppColors.textSubtle, fontSize: 14)),
                  SizedBox(height: 8),
                  Text(
                    'Your digital wellbeing companion.\n'
                    'Built to help you reclaim your time.',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lifetime stats
            const Text('Lifetime Stats',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSubtle,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _statRow('Total Interceptions',
                      '${AppPreferences.totalInterceptions}'),
                  _statRow('Times Changed Mind',
                      '${AppPreferences.totalChangedMind}'),
                  _statRow(
                      'Times Proceeded', '${AppPreferences.totalProceeded}'),
                  _statRow('Best Streak', '${AppPreferences.bestStreak}'),
                  _statRow('Mindfulness Score',
                      '${AppPreferences.mindfulnessScore.toStringAsFixed(1)}%'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reset
            const Text('Danger Zone',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _resetStats,
                icon: const Icon(Icons.delete_forever, color: AppColors.danger),
                label: const Text('Reset All Data',
                    style: TextStyle(color: AppColors.danger)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
