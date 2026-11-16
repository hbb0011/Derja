
import 'package:flutter/material.dart';
import '../models/word.dart';
import 'favorite_button.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final bool featured;
  final VoidCallback? onTap;

  const WordCard({
    super.key,
    required this.word,
    this.featured = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final meanings = word.english.split(' / ');
    final primaryMeaning = meanings.first;
    final otherMeanings = meanings.skip(1).join(' / ');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
              const SizedBox(width: 14), // gap between the text and the buttons
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Audio feature coming soon!')),
                  );
                },
                icon: const Icon(Icons.volume_up, color: Colors.white, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF315B3D),
                  side: const BorderSide(color: Color(0xFF171717), width: 2),
                  fixedSize: const Size(38, 38),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              FavoriteButton(wordId: word.id, size: 38),
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
              if (featured)
                IconButton(
                  onPressed: onTap ?? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Word details coming soon!'),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Color(0xFF171717),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF5),
              border: Border.all(
                color: const Color(0xFF171717),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              word.category,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF171717),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

void showWordDetails(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
          decoration: const BoxDecoration(
            color: Color(0xFFF7F1E5),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  word.arabic,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  word.derja,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF315B3D),
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  word.pronunciation,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF625D55),
                  ),
                ),

                const SizedBox(height: 20),

                const Divider(color: Color(0xFFD3C5AE)),

                const SizedBox(height: 12),

                const Text(
                  'MEANING',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFB94C3D),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  word.english,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'EXAMPLE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFB94C3D),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBD9B8),
                    border: Border.all(
                      color: const Color(0xFF171717),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.example,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        word.exampleTranslation,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF625D55),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF315B3D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    word.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
