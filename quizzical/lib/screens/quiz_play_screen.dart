import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/answer_button.dart';
import '../widgets/question_progress_bar.dart';
import '../widgets/retry_banner.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/timer_indicator.dart';
import 'results_screen.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Quit Quiz?'),
            content: const Text('Are you sure you want to quit? Your current progress will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Continue Quiz'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Quit', style: TextStyle(color: AppTheme.incorrect)),
              ),
            ],
          ),
        );

        if (shouldExit == true && context.mounted) {
          context.read<QuizProvider>().resetQuiz();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<QuizProvider>(
            builder: (context, provider, child) {
              final categoryName = provider.currentConfig?.category.name ?? 'Quiz';
              return Text(
                categoryName.replaceAll('Entertainment: ', '').replaceAll('Science: ', ''),
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          actions: [
            Consumer<QuizProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading || provider.currentQuestion == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: TimerIndicator(
                      remainingSeconds: provider.remainingSeconds,
                      totalSeconds: provider.questionDurationSeconds,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            // If quiz is completed, navigate automatically to ResultsScreen
            if (provider.isQuizCompleted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ResultsScreen()),
                );
              });
              return const Center(child: CircularProgressIndicator());
            }

            // Loading state with skeleton
            if (provider.isLoading) {
              return const QuestionSkeleton();
            }

            // Error state with retry preserving config
            if (provider.errorMessage != null) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RetryBanner(
                          message: provider.errorMessage!,
                          onRetry: () => provider.retryFetch(),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            provider.resetQuiz();
                            Navigator.pop(context);
                          },
                          child: const Text('Change Configuration'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final QuizQuestion? question = provider.currentQuestion;
            if (question == null) {
              return const Center(child: Text('No questions available.'));
            }

            return Column(
              children: [
                // Live Progress Bar and Score below AppBar
                QuestionProgressBar(
                  currentIndex: provider.currentIndex,
                  totalQuestions: provider.totalQuestions,
                  score: provider.score,
                ),

                // Question and Answers area
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Question Difficulty & Type tags
                            Row(
                              children: [
                                _buildBadge(
                                  question.difficulty.toUpperCase(),
                                  _getDifficultyColor(question.difficulty),
                                ),
                                const SizedBox(width: 8),
                                _buildBadge(
                                  question.type == 'boolean' ? 'TRUE / FALSE' : 'MULTIPLE CHOICE',
                                  AppTheme.textSecondary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Question Text Card
                            Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  question.question,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Timeout feedback banner if question timed out
                            if (question.isTimedOut)
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppTheme.warningLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.warning),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.timer_off_outlined, color: AppTheme.warning),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Time is up! Advancing to the next question...',
                                        style: TextStyle(
                                          color: Color(0xFF92400E),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Answer Buttons
                            ...question.shuffledAnswers.map((answer) {
                              return AnswerButton(
                                text: answer,
                                selectedAnswer: question.selectedAnswer,
                                correctAnswer: question.correctAnswer,
                                isAnswered: question.isAnswered,
                                onTap: () => provider.submitAnswer(answer),
                              );
                            }),

                            const SizedBox(height: 20),

                            // Next Button (enabled once answered)
                            if (question.isAnswered && !question.isTimedOut)
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: () => provider.nextQuestion(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        provider.currentIndex < provider.totalQuestions - 1
                                            ? 'Next Question'
                                            : 'View Results',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded, size: 20),
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'easy':
        return AppTheme.correct;
      case 'medium':
        return AppTheme.warning;
      case 'hard':
        return AppTheme.incorrect;
      default:
        return AppTheme.primary;
    }
  }
}
