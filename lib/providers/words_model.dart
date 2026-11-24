import 'package:flutter/foundation.dart';

import '../models/word.dart';
import '../services/api_service.dart';

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
  Future<void> loadWords() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // tell the screens: "show the spinner"

    try {
      _words = await ApiService.getWords();
    } catch (e) {
      // Remove the word "Exception:" so the message is nicer.
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners(); // tell the screens: "new data / error, redraw"
  }

  // --------------------------------------------------------------- POST
  /// Sends the new word to the server, then adds it to our local list.
  /// If the server fails, the exception goes up to the screen (which shows
  /// a red message).
  Future<void> addWord(Word word) async {
    final created = await ApiService.addWord(word); // wait for the server
    _words.add(created); // only if it worked, we update the list
    notifyListeners();
  }

  // ------------------------------------------------------------- DELETE
  /// Deletes the word on the server, then removes it from our local list.
  Future<void> deleteWord(Word word) async {
    await ApiService.deleteWord(word.id);
    _words.removeWhere((w) => w.id == word.id);
    notifyListeners();
  }

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
