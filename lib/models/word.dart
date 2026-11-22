/// MODEL = a Dart class that represents ONE item of our JSON database.
/// One JSON object in db.json  <->  one Word object in Dart.
class Word {
  final String id;
  final String derja; // Latin letters, e.g. "Aslema"
  final String arabic; // Arabic letters
  final String pronunciation; // how to read it, e.g. "As-le-ma"
  final String english; // English meaning
  final String category; // Greetings, Food...
  final String difficulty; // Beginner / Intermediate / Advanced
  final String explanation; // short explanation of how to use the word
  final String example; // example sentence in Derja
  final String exampleTranslation; // the sentence in English

  const Word({
    required this.id,
    required this.derja,
    required this.arabic,
    required this.pronunciation,
    required this.english,
    required this.category,
    required this.difficulty,
    required this.explanation,
    required this.example,
    required this.exampleTranslation,
  });

  /// JSON -> Word   (used when we READ from the server: GET)
  /// "json" is a Map like {"id": 1, "derja": "Aslema", ...}
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      // json-server may send the id as a number (1) or text ("1").
      // .toString() makes both cases work.
      id: json['id'].toString(),
      // "as String? ?? ''" = "if the field is missing, use an empty text"
      // so the app never crashes because of a missing field.
      derja: json['derja'] as String? ?? '',
      arabic: json['arabic'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ?? '',
      english: json['english'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      difficulty: json['difficulty'] as String? ?? 'Beginner',
      explanation: json['explanation'] as String? ?? '',
      example: json['example'] as String? ?? '',
      exampleTranslation: json['exampleTranslation'] as String? ?? '',
    );
  }

  /// Word -> JSON   (used when we SEND to the server: POST)
  /// We do NOT send the id: the server creates it by itself.
  Map<String, dynamic> toJson() {
    return {
      'derja': derja,
      'arabic': arabic,
      'pronunciation': pronunciation,
      'english': english,
      'category': category,
      'difficulty': difficulty,
      'explanation': explanation,
      'example': example,
      'exampleTranslation': exampleTranslation,
    };
  }
}
