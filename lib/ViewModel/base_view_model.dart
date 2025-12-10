import 'package:flutter/foundation.dart';

/// Provides shared loading and error state for all view models.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void runAsync(Future<void> Function() operation) async {
    setLoading(true);
    setError(null);
    try {
      await operation();
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading(false);
    }
  }
}
