import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word.dart';
import '../providers/favorites_model.dart';
import '../providers/words_model.dart';

/// The DELETE flow, shared by the detail screen and the profile screen:
///   1. ask "Are you sure?"
///   2. if yes -> send DELETE to the server (through WordsModel)
///   3. show a green or red message
/// Returns true if the word was really deleted.
Future<bool> confirmAndDeleteWord(BuildContext context, Word word) async {
  // We grab these BEFORE the `await`, because the context may not be valid
  // anymore after waiting.
  final messenger = ScaffoldMessenger.of(context);
  final words = context.read<WordsModel>();
  final favorites = context.read<FavoritesModel>();

  // 1. Confirmation dialog. It returns true / false (or null if dismissed).
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 40),
      title: const Text('Delete this word?'),
      content: Text(
        '"${word.derja}" will be removed from the database.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirmed != true) return false;

  // 2. DELETE request.
  try {
    await words.deleteWord(word);
    favorites.remove(word.id); // also remove it from the favorites
    messenger.showSnackBar(
      SnackBar(content: Text('"${word.derja}" deleted')),
    );
    return true;
  } catch (e) {
    // 3. The server failed: nothing was deleted.
    messenger.showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Could not delete: is json-server running?'),
      ),
    );
    return false;
  }
}
