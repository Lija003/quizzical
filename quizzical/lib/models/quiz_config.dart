import 'category.dart';

class QuizConfig {
  final TriviaCategory category;
  final int amount;
  final String difficulty; // 'any', 'easy', 'medium', 'hard'
  final String type; // 'any', 'multiple', 'boolean'
  final int timerDurationSeconds; // Default 20 or 30s

  const QuizConfig({
    required this.category,
    this.amount = 10,
    this.difficulty = 'any',
    this.type = 'any',
    this.timerDurationSeconds = 20,
  });

  QuizConfig copyWith({
    TriviaCategory? category,
    int? amount,
    String? difficulty,
    String? type,
    int? timerDurationSeconds,
  }) {
    return QuizConfig(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      timerDurationSeconds: timerDurationSeconds ?? this.timerDurationSeconds,
    );
  }

  /// Builds query parameters for OpenTDB questions API
  Map<String, String> toQueryParameters() {
    final params = <String, String>{
      'amount': amount.toString(),
      'category': category.id.toString(),
    };

    if (difficulty != 'any') {
      params['difficulty'] = difficulty.toLowerCase();
    }

    if (type != 'any') {
      params['type'] = type.toLowerCase();
    }

    return params;
  }
}
