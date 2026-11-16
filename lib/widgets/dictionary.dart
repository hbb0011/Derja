
import 'package:flutter/material.dart';
import '../models/word.dart';

class DictionaryWordCard extends StatelessWidget {
  final Word word;
  final VoidCallback onTap;

  const DictionaryWordCard({
    super.key,
    required this.word,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFFEBD9B8),
          border: Border.all(
            color: const Color(0xFF171717),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(19),
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

            // ARABIC WORD AND AUDIO BUTTON
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.arabic,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF171717),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    // Audio functionality will be connected later.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Audio coming soon!'),
                        duration: Duration(seconds: 1),
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
                    fixedSize: const Size(40, 40),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // TUNISIAN PRONUNCIATION
            Text(
              word.derja,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF315B3D),
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              word.pronunciation,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF746B5D),
              ),
            ),

            const SizedBox(height: 15),

            // DIVIDER
            Container(
              height: 1.5,
              color: const Color(0xFFB7A78B),
            ),

            const SizedBox(height: 12),

            // MEANING AND CATEGORY
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.english,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF171717),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
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
                    word.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF171717),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'TAP TO LEARN MORE',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF746B5D),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward,
                  size: 13,
                  color: Color(0xFF746B5D),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
