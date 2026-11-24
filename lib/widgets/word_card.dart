import 'package:flutter/material.dart';

import '../models/category_info.dart';
import '../models/word.dart';
import '../screens/word_details_screen.dart';
import '../theme/app_colors.dart';
import 'favorite_button.dart';
import 'hard_card.dart';
import 'small_widgets.dart';
import 'speak_button.dart';

/// One word in a list (Dictionary, Favorites, Home "word of the day").
/// Tap the card -> opens the detail screen with the explanation + example.
class WordCard extends StatelessWidget {
  final Word word;
  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    // Find the colour of this word's category (fallback = sand).
    final info = kCategories.where((c) => c.name == word.category);
    final color = info.isEmpty ? AppColors.sand : info.first.color;

    return HardCard(
      color: color,
      onTap: () {
        // Navigator.push = open a new screen on top of the current one.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WordDetailScreen(word: word)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Row 1: Arabic word (left) + the 2 buttons (right) ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    word.arabic,
                    textDirection: TextDirection.rtl, // Arabic = right to left
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  SpeakButton(word: word),
                  const SizedBox(height: 8),
                  FavoriteButton(word: word),
                ],
              ),
            ],
          ),

          // ---- Row 2: the Latin spelling ----
          Text(
            word.derja,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Divider(color: Color(0x33000000), thickness: 1, height: 22),

          // ---- Row 3: English meaning + arrow ----
          Row(
            children: [
              Expanded(
                child: Text(
                  word.english,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.ink),
            ],
          ),
          const SizedBox(height: 8),

          // ---- Row 4: tags ----
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [Tag(word.category), Tag(word.difficulty)],
          ),
        ],
      ),
    );
  }
}
