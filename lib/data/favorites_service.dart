import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._(); 
  static final FavoritesService instance = FavoritesService._();

  static const String _storageKey = 'favorite_word_ids';

  final Set<int> _ids = {};
  bool _loaded = false;

  bool isFavorite(int wordId) => _ids.contains(wordId);

  int get count => _ids.length;

  /// Call once at app start so favorites survive restarts.
  Future<void> load() async {
    if (_loaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_storageKey) ?? const [];

      _ids
        ..clear()
        ..addAll(saved.map(int.tryParse).whereType<int>());
    } catch (e) {
      debugPrint('Could not load favorites: $e');
    }

    _loaded = true;
    notifyListeners();
  }

  /// Adds the word if it is not a favorite, removes it if it is.
  Future<void> toggle(int wordId) async {
    if (!_ids.add(wordId)) {
      _ids.remove(wordId);
    }

    notifyListeners(); 
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _storageKey,
        _ids.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      debugPrint('Could not save favorites: $e');
    }
  }
}