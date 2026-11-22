import 'package:flutter/material.dart';

/// ANIMATION #1: makes its child fade in while sliding up a little.
///
/// How it works: TweenAnimationBuilder runs a number from 0 to 1.
/// At each step it calls `builder` with the current number (`value`),
/// and we use it for the opacity (0 = invisible, 1 = visible)
/// and for the vertical position (20 pixels lower -> 0 pixels).
///
/// `index` = position in the list. Bigger index = slightly slower,
/// so the cards appear one after the other.
class FadeInUp extends StatelessWidget {
  final Widget child;
  final int index;

  const FadeInUp({super.key, required this.child, this.index = 0});

  @override
  Widget build(BuildContext context) {
    // Max 8 steps of delay, otherwise the end of a long list would be too slow.
    final step = index > 8 ? 8 : index;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + step * 70),
      curve: Curves.easeOut,
      child: child, // built once and reused at every animation step
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}
