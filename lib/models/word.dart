
class Word {
  final int id;
  final String derja;
  final String arabic;
  final String pronunciation;
  final String english;
  final String category;
  final String difficulty;
  final String example;
  final String exampleTranslation;
  final String? audio;
  

  Word({
    required this.id,
    required this.derja,
    required this.arabic,
    required this.pronunciation,
    required this.english,
    required this.category,
    required this.difficulty,
    required this.example,
    required this.exampleTranslation,
    required this.audio

 
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      derja: json['derja'],
      arabic: json['arabic'],
      pronunciation: json['pronunciation'],
      english: json['english'],
      category: json['category'],
      difficulty: json['difficulty'],
      example: json['example'],
      exampleTranslation: json['example_translation'],
      audio: json['audio']
    );
  
  }
}

extension WordSearch on Word {
  bool matchesQuery(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return true;
    return derja.toLowerCase().contains(q) ||
        arabic.contains(q) ||
        english.toLowerCase().contains(q) ||
        pronunciation.toLowerCase().contains(q);
  }
}
