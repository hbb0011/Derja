import 'package:flutter/material.dart';

import '../models/word.dart';
import '../theme/app_colors.dart';
import '../widgets/delete_word.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/favorite_button.dart';
import '../widgets/hard_card.dart';
import '../widgets/small_widgets.dart';
import '../widgets/speak_button.dart';

/// Opens when you tap a word. Shows:
///   - the word in Arabic + Derja + pronunciation + meaning
///   - an EXPLANATION of how to use it
///   - an EXAMPLE sentence (tap it to reveal the English translation)
///   - a DELETE button
///
/// It's a StatefulWidget because it remembers one thing that can change:
/// "is the translation visible or hidden?" (_showTranslation).
class WordDetailScreen extends StatefulWidget {
  final Word word;
  const WordDetailScreen({super.key, required this.word});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  bool _showTranslation = false;

  Future<void> _delete() async {
    final deleted = await confirmAndDeleteWord(context, widget.word);
    // `mounted` = "is this screen still on the display?" (always check it
    // after an await before using the context again).
    if (deleted && mounted) {
      Navigator.pop(context); // go back to the list
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ---- Top bar: back arrow + heart ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButton(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: AppColors.ink),
                ),
                FavoriteButton(word: word),
              ],
            ),
            const SizedBox(height: 20),

            // ---- Big card with the word ----
            FadeInUp(
              child: HardCard(
                color: AppColors.sand,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      word.arabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 52, fontWeight: FontWeight.w700, color: AppColors.ink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      word.derja,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 26,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Pronunciation line with the speaker button
                    if (word.pronunciation.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpeakButton(word: word),
                          const SizedBox(width: 10),
                          Text('Say it: ${word.pronunciation}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink)),
                        ],
                      ),
                    const Divider(
                        color: Color(0x33000000), thickness: 1, height: 32),
                    Text(
                      word.english,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.center,
                      children: [Tag(word.category), Tag(word.difficulty)],
                    ),
                  ],
                ),
              ),
            ),

            // ---- Explanation ----
            if (word.explanation.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionLabel('What it means'),
              const SizedBox(height: 8),
              FadeInUp(
                index: 1,
                child: HardCard(
                  child: Text(
                    word.explanation,
                    style: const TextStyle(fontSize: 16, height: 1.4, color: AppColors.ink),
                  ),
                ),
              ),
            ],

            // ---- Example sentence ----
            if (word.example.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionLabel('Example'),
              const SizedBox(height: 8),
              FadeInUp(
                index: 2,
                child: HardCard(
                  // Tapping the card flips _showTranslation (true <-> false).
                  // setState = "redraw the screen with the new value".
                  onTap: () =>
                      setState(() => _showTranslation = !_showTranslation),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.example,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ANIMATION #3: AnimatedCrossFade smoothly swaps between
                      // two widgets (first -> second) when crossFadeState
                      // changes.
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _showTranslation
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Tap to see the translation',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        ),
                        secondChild: SizedBox(
                          width: double.infinity,
                          child: Text(
                            word.exampleTranslation,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ---- Delete button ----
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete this word'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
