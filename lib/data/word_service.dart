import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

class WordService {
  static final ValueNotifier<int> version = ValueNotifier<int>(0); // the bell
  static final List<Word> _addedWords = []; // temporary

  static Future<List<Word>> getWords() async {
    final response = await rootBundle.loadString(
      'assets/data/words.json',
    );

    final List<dynamic> data = jsonDecode(response);

        final fromJson = data.map((item) => Word.fromJson(item)).toList();
    return [...fromJson, ..._addedWords];
  }

  static Future<List<Word>> getWordsByCategory(
    String category,
  ) async {
    final words = await getWords();

    return words.where(
      (word) => word.category == category,
    ).toList();
  }


    static Future<void> addWord({
    required String derja,
    required String arabic,
    required String english,
    String pronunciation = '',
    String category = 'My words',
    String difficulty = 'Beginner',
    String example = '',
    String exampleTranslation = '',
    String audio = '',
  }) async {
    final words = await getWords();

    var newId = 1000;
    for (final w in words) {
      if (w.id >= newId) newId = w.id + 1;
    }

    _addedWords.add(
      Word(
        id: newId,
        derja: derja,
        arabic: arabic,
        pronunciation: pronunciation,
        english: english,
        category: category,
        difficulty: difficulty,
        example: example,
        exampleTranslation: exampleTranslation,
        audio: audio
      ),
    );

    version.value++; // ring the bell
  }

static Future<Word?> getWordOfTheDay() async {
  final words = await getWords();

  if (words.isEmpty) return null;

  return words.first;
}

  static Future<List<Word>> searchWords(String query) async {
    final words = await getWords();
    final q = query.toLowerCase().trim();

    return words.where((word) {
      return word.derja.toLowerCase().contains(q) ||
          word.arabic.contains(q) ||
          word.english.toLowerCase().contains(q);
    }).toList();
  }

}
