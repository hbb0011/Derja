import '../widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import '../models/word.dart';
import '../data/favorites_service.dart';
import '../widgets/favorite_button.dart';

//delete later
class WordOfDayCard extends StatelessWidget {
  final Word word;

  const WordOfDayCard({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final meanings = word.english.split(' / ');
    final primaryMeaning = meanings.first;
    final otherMeanings = meanings.skip(1).join(' / ');

   return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEBD9B8),
        border: Border.all(
          color: const Color(0xFF171717),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF171717),
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  word.arabic,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF171717),
                  ),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Audio feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 19,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF315B3D),
                      side: const BorderSide(
                        color: Color(0xFF171717),
                        width: 2,
                      ),
                      fixedSize: const Size(42, 42),
                    ),
                  ),

                  const SizedBox(height: 8),

                  FavoriteButton(wordId: word.id),
                ],
              ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            word.derja,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: Color(0xFF315B3D),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            height: 1.5,
            color: const Color(0xFFB7A78B),
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: primaryMeaning,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF171717),
                        ),
                      ),
                      if (otherMeanings.isNotEmpty)
                        TextSpan(
                          text: ' / $otherMeanings',
                          style: const TextStyle(
                            color: Color(0xFF746B5D),
                          ),
                        ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),

              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Word details coming soon!'),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF171717),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
/*extension WordSearch on Word {
  bool matchesQuery(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return true;
    return derja.toLowerCase().contains(q) ||
        arabic.contains(q) ||
        english.toLowerCase().contains(q) ||
        pronunciation.toLowerCase().contains(q);
  }
}*/