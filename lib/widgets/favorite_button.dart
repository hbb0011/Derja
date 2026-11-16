import 'package:flutter/material.dart';
import '../data/favorites_service.dart';

class FavoriteButton extends StatelessWidget {
  final int wordId;
  final double size;

  const FavoriteButton({
    super.key,
    required this.wordId,
    this.size = 42,
  });

  static const Color _ink = Color(0xFF171717);
  static const Color _cream = Color(0xFFFFFCF5);
  static const Color _red = Color(0xFFB94C3D);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final isFavorite = FavoritesService.instance.isFavorite(wordId);
        final shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _ink, width: 2),
        );

        return Tooltip(
          message: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          child: Material(
            color: isFavorite ? _red : _cream,
            shape: shape,
            child: InkWell(
              customBorder: shape,
              onTap: () => FavoritesService.instance.toggle(wordId),
              child: SizedBox(
                width: size,
                height: size,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isFavorite),
                      size: 21,
                      color: isFavorite ? Colors.white : _ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
