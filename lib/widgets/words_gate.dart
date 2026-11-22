import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/words_model.dart';
import '../theme/app_colors.dart';
import 'network_error.dart';

/// WordsGate = a "door" every screen goes through.
/// It decides what to show:
///   - still loading        -> a spinner
///   - error, no data       -> the error message + "Try again" button
///   - otherwise            -> the screen content (given by `builder`)
///
/// Written once here, so the 4 screens don't repeat this logic
/// (in Rihla we did the same with FutureBuilder).
class WordsGate extends StatelessWidget {
  final Widget Function(BuildContext context, WordsModel words) builder;

  const WordsGate({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    // watch = "redraw me whenever the model calls notifyListeners()"
    final words = context.watch<WordsModel>();

    if (words.isLoading && words.all.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.green),
      );
    }

    if (words.error != null && words.all.isEmpty) {
      return NetworkError(
        message: words.error!,
        onRetry: () => words.loadWords(),
      );
    }

    return builder(context, words);
  }
}
