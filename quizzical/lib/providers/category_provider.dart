import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  CategoryProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<TriviaCategory> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCached = false;

  List<TriviaCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCached => _isCached;

  /// Loads categories once during the session. If already loaded, uses cached data unless forceRefresh is true.
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    if (_isCached && !forceRefresh && _categories.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _apiService.fetchCategories();
      _categories = fetched;
      _isCached = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
