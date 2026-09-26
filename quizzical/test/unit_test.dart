import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/models/category.dart';
import 'package:quizzical/models/quiz_config.dart';
import 'package:quizzical/models/quiz_question.dart';
import 'package:quizzical/utils/html_unescape_helper.dart';

void main() {
  group('HtmlUnescapeHelper Tests', () {
    test('Unescapes basic and common HTML entities', () {
      expect(
        HtmlUnescapeHelper.unescape('What was the name of &#039;The Doctor&#039;?'),
        "What was the name of 'The Doctor'?",
      );
      expect(
        HtmlUnescapeHelper.unescape('&quot;Quizzical&quot; &amp; Fun'),
        '"Quizzical" & Fun',
      );
      expect(
        HtmlUnescapeHelper.unescape('Caf&eacute; &copy; 2026'),
        'Café © 2026',
      );
    });

    test('Unescapes decimal and hex numeric entities', () {
      expect(HtmlUnescapeHelper.unescape('&#65;&#66;&#67;'), 'ABC');
      expect(HtmlUnescapeHelper.unescape('&#x41;&#x42;&#x43;'), 'ABC');
    });
  });

  group('TriviaCategory Model Tests', () {
    test('Deserializes category JSON correctly', () {
      final json = {'id': 9, 'name': 'General Knowledge'};
      final category = TriviaCategory.fromJson(json);

      expect(category.id, 9);
      expect(category.name, 'General Knowledge');
    });
  });

  group('QuizConfig Tests', () {
    test('Generates expected query parameters for OpenTDB', () {
      final category = TriviaCategory(id: 18, name: 'Science: Computers');
      final config = QuizConfig(
        category: category,
        amount: 15,
        difficulty: 'easy',
        type: 'multiple',
      );

      final params = config.toQueryParameters();
      expect(params['amount'], '15');
      expect(params['category'], '18');
      expect(params['difficulty'], 'easy');
      expect(params['type'], 'multiple');
    });

    test('Omits difficulty and type when set to "any"', () {
      final category = TriviaCategory(id: 9, name: 'General Knowledge');
      final config = QuizConfig(
        category: category,
        amount: 10,
        difficulty: 'any',
        type: 'any',
      );

      final params = config.toQueryParameters();
      expect(params['amount'], '10');
      expect(params['category'], '9');
      expect(params.containsKey('difficulty'), false);
      expect(params.containsKey('type'), false);
    });
  });

  group('QuizQuestion Model Tests', () {
    test('Decodes and prepares shuffled answers with single correct answer', () {
      final json = {
        'category': 'General Knowledge',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'How many colors are there in a &quot;rainbow&quot;?',
        'correct_answer': '7',
        'incorrect_answers': ['8', '9', '10'],
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.question, 'How many colors are there in a "rainbow"?');
      expect(question.correctAnswer, '7');
      expect(question.shuffledAnswers.length, 4);
      expect(question.shuffledAnswers.contains('7'), true);
      expect(question.shuffledAnswers.where((a) => a == '7').length, 1);
    });

    test('Boolean question has True and False', () {
      final json = {
        'category': 'General Knowledge',
        'type': 'boolean',
        'difficulty': 'easy',
        'question': 'When you cry in space, your tears stick to your face.',
        'correct_answer': 'True',
        'incorrect_answers': ['False'],
      };

      final question = QuizQuestion.fromJson(json);

      expect(question.correctAnswer, 'True');
      expect(question.shuffledAnswers, ['True', 'False']);
    });
  });
}
