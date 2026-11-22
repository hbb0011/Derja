import 'package:flutter/material.dart';

/// Shown when the server can't be reached (same idea as ErreurReseau in Rihla).
class NetworkError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off,
                color: Theme.of(context).colorScheme.error, size: 64),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            const Text('Check that json-server is running.',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
