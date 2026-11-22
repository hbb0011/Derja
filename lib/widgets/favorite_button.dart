import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word.dart';
import '../providers/favorites_model.dart';
import '../theme/app_colors.dart';
import 'small_widgets.dart';

/// The heart button. Tap = add / remove from favorites.
class FavoriteButton extends StatelessWidget {
  final Word word;
  const FavoriteButton({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    // watch: the heart redraws when favorites change.
    final isFav = context.watch<FavoritesModel>().isFavorite(word.id);

    return CircleButton(
      // read: we just call a method, no need to redraw because of it.
      onTap: () => context.read<FavoritesModel>().toggle(word.id),

      // ANIMATION #2: AnimatedSwitcher animates the change between two
      // widgets. The heart "pops" (scales) when it changes.
      // The `key` tells Flutter "this is a DIFFERENT widget" so it animates.
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFav),
          color: isFav ? AppColors.red : AppColors.ink,
        ),
      ),
    );
  }
}
