import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favorites shared by all the screens (same idea as FavorisModel in Rihla).
/// We only keep the IDS of the favorite words. The real words come from
/// WordsModel. So if a word is deleted, it can't stay "ghost" in favorites.
///
/// (Favorites live in memory only: they reset when you close the app.)
class FavoritesModel extends ChangeNotifier {
  static const String _cle = 'favoris';
  final Set<String> _ids = {}; // a Set = a list with no duplicates

  Set<String> get ids => _ids;
  int get count => _ids.length;
  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final favorisSauvegardes = prefs.getStringList(_cle) ?? [];
    

    _ids
      ..clear()
      ..addAll(favorisSauvegardes);

    notifyListeners();
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_cle, _ids.toList());
    
  }

  bool isFavorite(String id) => _ids.contains(id);

  /// Add if absent, remove if present.
  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    _sauvegarder();
    notifyListeners(); // redraw every heart and the badge
  }

  void remove(String id) {
    _ids.remove(id);
    _sauvegarder();
    notifyListeners();
  }
}
