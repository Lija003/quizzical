import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/quiz_config.dart';
import '../models/quiz_question.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://opentdb.com';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the list of all trivia categories.
  Future<List<TriviaCategory>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/api_category.php');
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('trivia_categories')) {
          final List<dynamic> list = data['trivia_categories'];
          return list.map((item) => TriviaCategory.fromJson(item)).toList();
        } else {
          throw ApiException('Unexpected data format received from category API.');
        }
      } else {
        throw ApiException('Failed to load categories (HTTP ${response.statusCode}).');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unable to connect to OpenTDB. Please check your internet connection.');
    }
  }

  /// Fetches questions based on configuration.
  Future<List<QuizQuestion>> fetchQuestions(QuizConfig config) async {
    final queryParams = config.toQueryParameters();
    final uri = Uri.parse('$_baseUrl/api.php').replace(queryParameters: queryParams);

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final int responseCode = data['response_code'] as int? ?? -1;

        switch (responseCode) {
          case 0:
            final List<dynamic> results = data['results'] as List<dynamic>? ?? [];
            if (results.isEmpty) {
              throw ApiException('No questions found for the selected criteria.');
            }
            return results.map((item) => QuizQuestion.fromJson(item)).toList();
          case 1:
            throw ApiException(
              'Not enough questions available for category "${config.category.name}" '
              'with difficulty "${config.difficulty}". Please try fewer questions or different options.',
            );
          case 2:
            throw ApiException('Invalid query parameters provided to the server.');
          case 5:
            throw ApiException('Rate limit reached. Please wait a few seconds before trying again.');
          default:
            throw ApiException('Failed to fetch questions (API Code: $responseCode).');
        }
      } else {
        throw ApiException('Server error (HTTP ${response.statusCode}). Please try again.');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error fetching questions. Please verify your connection.');
    }
  }
}
