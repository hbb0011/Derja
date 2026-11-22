import 'package:flutter/foundation.dart';

/// Favorites shared by all the screens (same idea as FavorisModel in Rihla).
/// We only keep the IDS of the favorite words. The real words come from
/// WordsModel. So if a word is deleted, it can't stay "ghost" in favorites.
///
/// (Favorites live in memory only: they reset when you close the app.)
class FavoritesModel extends ChangeNotifier {
  final Set<String> _ids = {}; // a Set = a list with no duplicates

  Set<String> get ids => _ids;
  int get count => _ids.length;

  bool isFavorite(String id) => _ids.contains(id);

  /// Add if absent, remove if present.
  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners(); // redraw every heart and the badge
  }

  void remove(String id) {
    _ids.remove(id);
    notifyListeners();
  }
}
