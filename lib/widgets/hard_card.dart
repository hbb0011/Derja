import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// HardCard = the "look" of the app: a card with a thick black border and a
/// hard (not blurry) shadow offset to the bottom-right.
/// We use it everywhere, so the style lives in ONE place.
class HardCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap; // if given, the card becomes tappable
  final double radius;
  final double shadow; // size of the hard shadow

  const HardCard({
    super.key,
    required this.child,
    this.color = AppColors.paper,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.radius = 20,
    this.shadow = 4,
  });

  @override
  Widget build(BuildContext context) {
    // The visible box: colour + border + hard shadow.
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: [
          BoxShadow(color: AppColors.ink, offset: Offset(shadow, shadow)),
        ],
      ),
      child: child,
    );

    // The outer Padding leaves room so the shadow is not cut by the screen.
    return Padding(
      padding: EdgeInsets.only(right: shadow, bottom: shadow),
      child: onTap == null
          ? box
          : GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: box,
            ),
    );
  }
}
