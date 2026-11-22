import 'package:flutter/foundation.dart';

import '../models/word.dart';

/// WordsModel = the "memory" of the app for the words.
///
/// WHY a model? Many screens need the same words (Home, Dictionary,
/// Favorites, Profile). If every screen called the server itself we would
/// download the list 4 times, and a delete in one screen would not show in the
/// others. With ONE shared model:
///   1. we load the words once,
///   2. when the list changes we call notifyListeners(),
///   3. every screen that "watches" the model redraws itself automatically.
class WordsModel extends ChangeNotifier {
  List<Word> _words = []; // all the words received from the server
  bool _isLoading = false; // true while we wait for the server
  String? _error; // error message, or null if everything is OK

  // The current filter of the Dictionary screen.
  String category = 'All';
  String query = '';

  // ---- read-only getters used by the screens ----
  List<Word> get all => _words;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// The words after applying the category chip AND the search text.
  List<Word> get filtered {
    final q = query.trim().toLowerCase();
    return _words.where((w) {
      final okCategory = category == 'All' || w.category == category;
      final okSearch = q.isEmpty ||
          w.derja.toLowerCase().contains(q) ||
          w.english.toLowerCase().contains(q) ||
          w.pronunciation.toLowerCase().contains(q) ||
          w.arabic.contains(q);
      return okCategory && okSearch;
    }).toList();
  }

  /// "Word of the day": the position depends on today's date,
  /// so it changes every day but stays the same all day long.
  Word? get wordOfTheDay {
    if (_words.isEmpty) return null;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return _words[dayOfYear % _words.length];
  }

  // ---------------------------------------------------------------- GET
  /// Downloads the words from the server.
 

  // ------------------------------------------------------------ filters
  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  /// Sets both filters at once (used by the Home screen shortcuts).
  void setFilter({String category = 'All', String query = ''}) {
    this.category = category;
    this.query = query;
    notifyListeners();
  }
}
