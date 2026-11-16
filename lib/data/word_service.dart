
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

class WordService {
  static Future<List<Word>> getWords() async {
    final response = await rootBundle.loadString(
      'assets/data/words.json',
    );

    final List<dynamic> data = jsonDecode(response);

    return data.map((item) => Word.fromJson(item)).toList();
  }

  static Future<List<Word>> getWordsByCategory(
    String category,
  ) async {
    final words = await getWords();

    return words.where(
      (word) => word.category == category,
    ).toList();
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
