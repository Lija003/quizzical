import '../utils/html_unescape_helper.dart';

class QuizQuestion {
  final String category;
  final String type; // 'multiple' or 'boolean'
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> shuffledAnswers;

  String? selectedAnswer;
  bool isTimedOut;

  QuizQuestion({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.shuffledAnswers,
    this.selectedAnswer,
    this.isTimedOut = false,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['category'] as String? ?? '';
    final rawType = json['type'] as String? ?? 'multiple';
    final rawDifficulty = json['difficulty'] as String? ?? 'easy';
    final rawQuestion = json['question'] as String? ?? '';
    final rawCorrect = json['correct_answer'] as String? ?? '';
    final rawIncorrectList = (json['incorrect_answers'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    // Decode HTML entities
    final decodedCategory = HtmlUnescapeHelper.unescape(rawCategory);
    final decodedQuestion = HtmlUnescapeHelper.unescape(rawQuestion);
    final decodedCorrect = HtmlUnescapeHelper.unescape(rawCorrect);
    final decodedIncorrect = rawIncorrectList
        .map((ans) => HtmlUnescapeHelper.unescape(ans))
        .toList();

    // Prepare shuffled answers
    final List<String> answers = [decodedCorrect, ...decodedIncorrect];
    if (rawType == 'boolean') {
      // For boolean, keep standard ['True', 'False'] order for better UX
      answers.sort((a, b) => b.compareTo(a)); // True first, then False
    } else {
      // Shuffle multiple choice answers
      answers.shuffle();
    }

    return QuizQuestion(
      category: decodedCategory,
      type: rawType,
      difficulty: rawDifficulty,
      question: decodedQuestion,
      correctAnswer: decodedCorrect,
      incorrectAnswers: decodedIncorrect,
      shuffledAnswers: answers,
    );
  }

  bool get isAnswered => selectedAnswer != null || isTimedOut;

  bool get isCorrect => selectedAnswer == correctAnswer;
}
