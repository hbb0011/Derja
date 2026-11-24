import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/word.dart';

/// ApiService = the ONLY file that talks to the server.
/// Screens never call http directly, they ask the model, and the model asks
/// this service.
///
/// The 3 REST requests we use:
///   GET    /words        -> read all the words
///   POST   /words        -> add a new word      (profile form)
///   DELETE /words/5      -> delete the word with id 5
class ApiService {
  /// Builds the full address: "http://localhost:3000" + "/words"
  static Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  // ---------------------------------------------------------------- GET
  /// Asks the server for the list of all words.
  static Future<List<Word>> getWords() async {
    final response = await http.get(_url('/words')).timeout(ApiConfig.timeout);

    // 200 = OK. Anything else = problem, so we stop with an error.
    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode} while loading the words');
    }

    // The server answers with TEXT. We turn it into a Dart List.
    // utf8.decode keeps the Arabic letters and accents correct.
    final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

    // Each item of the list is a Map -> we turn it into a Word object.
    return list.map((json) => Word.fromJson(json)).toList();
  }

  // --------------------------------------------------------------- POST
  /// Sends a new word to the server. Returns the word the server created
  /// (the same word, but now WITH its id).
  static Future<Word> addWord(Word word) async {
    final response = await http
        .post(
          _url('/words'),
          // We tell the server: "the body is JSON".
          headers: {'Content-Type': 'application/json'},
          // Word -> Map -> JSON text
          body: jsonEncode(word.toJson()),
        )
        .timeout(ApiConfig.timeout);

    // 201 = "Created".
    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode} while adding the word');
    }

    final Map<String, dynamic> created =
        jsonDecode(utf8.decode(response.bodyBytes));
    return Word.fromJson(created);
  }

  // ------------------------------------------------------------- DELETE
  /// Deletes ONE word. The id is written in the address: /words/5
  static Future<void> deleteWord(String id) async {
    final response =
        await http.delete(_url('/words/$id')).timeout(ApiConfig.timeout);

    // json-server answers 200 (or 204) when the delete worked.
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error ${response.statusCode} while deleting the word');
    }
  }
}
