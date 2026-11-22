
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'hard_card.dart';
class SearchBox extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged; // called at every letter typed
  final ValueChanged<String>? onSubmitted; // called when pressing Enter

  const SearchBox({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });
   @override
  Widget build(BuildContext context) {
    return HardCard(
      color: Colors.white,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(Icons.search),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.muted),
        ),
      ),
    );
  }
}
