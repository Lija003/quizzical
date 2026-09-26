import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_theme.dart';
import 'category_selection_screen.dart';
import 'quiz_config_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    if (mins > 0) {
      return '${mins}m ${remainingSecs}s';
    }
    return '${remainingSecs}s';
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final score = quizProvider.score;
    final total = quizProvider.totalQuestions;
    final accuracy = quizProvider.accuracyPercentage;
    final totalTime = quizProvider.totalElapsedSeconds;
    final category = quizProvider.currentConfig?.category;

    // Feedback message based on performance
    String performanceTitle;
    String performanceSubtitle;
    IconData performanceIcon;
    Color performanceColor;

    if (accuracy >= 80) {
      performanceTitle = 'Outstanding!';
      performanceSubtitle = 'You really know your trivia!';
      performanceIcon = Icons.military_tech_rounded;
      performanceColor = const Color(0xFFF59E0B); // Gold
    } else if (accuracy >= 50) {
      performanceTitle = 'Well Done!';
      performanceSubtitle = 'Good job! Keep learning and practice more.';
      performanceIcon = Icons.thumb_up_rounded;
      performanceColor = AppTheme.primary;
    } else {
      performanceTitle = 'Nice Try!';
      performanceSubtitle = 'Don’t give up! Try again to beat your score.';
      performanceIcon = Icons.refresh_rounded;
      performanceColor = AppTheme.accent;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        quizProvider.resetQuiz();
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Badge / Trophy Icon
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: performanceColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          performanceIcon,
                          color: performanceColor,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title & Subtitle
                    Text(
                      performanceTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      performanceSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Prominent Score Card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'YOUR FINAL SCORE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$score / $total',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You scored $score out of $total questions!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatTile(
                            icon: Icons.percent_rounded,
                            label: 'Accuracy',
                            value: '${accuracy.toStringAsFixed(0)}%',
                            color: AppTheme.correct,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatTile(
                            icon: Icons.timer_outlined,
                            label: 'Total Time',
                            value: _formatDuration(totalTime),
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatTile(
                            icon: Icons.check_circle_outline,
                            label: 'Correct',
                            value: '$score',
                            color: AppTheme.correct,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatTile(
                            icon: Icons.highlight_off_rounded,
                            label: 'Incorrect / Skipped',
                            value: '${total - score}',
                            color: AppTheme.incorrect,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Play Again CTA button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Reset quiz state
                          quizProvider.resetQuiz();

                          if (category != null) {
                            // Replay with preserved config
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizConfigScreen(category: category),
                              ),
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategorySelectionScreen(),
                              ),
                              (route) => route.isFirst,
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.replay_rounded, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Play Again',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Back to Categories / Home button
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          quizProvider.resetQuiz();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategorySelectionScreen(),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.category_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Choose Different Category',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
