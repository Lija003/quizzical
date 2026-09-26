import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyAmount = 'last_quiz_amount';
  static const String _keyDifficulty = 'last_quiz_difficulty';
  static const String _keyType = 'last_quiz_type';
  static const String _keyCategoryId = 'last_quiz_category_id';

  /// Saves the last chosen configuration
  static Future<void> saveConfig({
    required int amount,
    required String difficulty,
    required String type,
    int? categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAmount, amount);
    await prefs.setString(_keyDifficulty, difficulty);
    await prefs.setString(_keyType, type);
    if (categoryId != null) {
      await prefs.setInt(_keyCategoryId, categoryId);
    }
  }

  /// Retrieves the saved configuration defaults
  static Future<Map<String, dynamic>> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'amount': prefs.getInt(_keyAmount) ?? 10,
      'difficulty': prefs.getString(_keyDifficulty) ?? 'any',
      'type': prefs.getString(_keyType) ?? 'any',
      'categoryId': prefs.getInt(_keyCategoryId),
    };
  }
}
