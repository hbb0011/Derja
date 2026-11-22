import 'package:flutter/material.dart';

import '../models/word.dart';
import '../theme/app_colors.dart';
import 'small_widgets.dart';

/// The green speaker button.
/// Real audio would need an extra package (like flutter_tts), so to keep the
/// project simple we show how to pronounce the word in a small message.
class SpeakButton extends StatelessWidget {
  final Word word;
  const SpeakButton({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      background: AppColors.green,
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('speak feature coming soon! (word: ${word.arabic})'),
              duration: const Duration(seconds: 2),
            ),
          );
      },
      child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
    );
  }
}
