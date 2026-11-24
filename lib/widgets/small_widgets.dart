import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Small reusable pieces. Each one is tiny, so we keep them together.

// ---------------------------------------------------------------------------
/// The red square logo at the top of the screens.
class AppLogo extends StatelessWidget {
  final IconData icon;
  const AppLogo({super.key, this.icon = Icons.translate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(3, 3)),
        ],
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

// ---------------------------------------------------------------------------
/// Small UPPERCASE title, e.g. "EXPLORE CATEGORIES".
class SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const SectionLabel(this.text, {super.key, this.color = AppColors.green});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
/// A small label with a border, e.g. "Greetings" or "Beginner".
class Tag extends StatelessWidget {
  final String text;
  final Color color;
  const Tag(this.text, {super.key, this.color = AppColors.paper});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
/// A round button with a border (used for the heart, speaker, back arrow).
/// The `child` is whatever we want inside (usually an Icon).
class CircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color background;
  final double size;

  const CircleButton({
    super.key,
    required this.child,
    required this.onTap,
    this.background = AppColors.paper,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.ink, width: 2),
        ),
        child: child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
/// The filter chip (All / Food / ...). Green when selected.
class AppChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.paper,
      selectedColor: AppColors.green,
      side: const BorderSide(color: AppColors.ink, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
