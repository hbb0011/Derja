import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_model.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/small_widgets.dart';
import '../widgets/word_card.dart';
import '../widgets/words_gate.dart';

/// Tab 3: the words you hearted.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WordsGate(
      builder: (context, words) {
        final favoriteIds = context.watch<FavoritesModel>().ids;

        // Keep only the words whose id is in the favorites.
        final favorites =
            words.all.where((w) => favoriteIds.contains(w.id)).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            const Row(
              children: [
                AppLogo(icon: Icons.favorite),
                SizedBox(width: 12),
                Text('Favorites',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),

            // Nothing hearted yet -> friendly empty message.
            if (favorites.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Icon(Icons.favorite_border,
                        size: 64, color: AppColors.muted),
                    SizedBox(height: 12),
                    Text('No favorites yet',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Tap the heart on a word to save it here.',
                        style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),

            for (final entry in favorites.asMap().entries)
              Padding(
                key: ValueKey(entry.value.id),
                padding: const EdgeInsets.only(bottom: 16),
                child: FadeInUp(
                  index: entry.key,
                  child: WordCard(word: entry.value),
                ),
              ),
          ],
        );
      },
    );
  }
}
