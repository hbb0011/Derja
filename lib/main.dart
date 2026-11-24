import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_model.dart';
import 'providers/words_model.dart';
import 'screens/main_screen.dart';
import 'theme/app_colors.dart';

/// The app starts here.
void main() {
  runApp(
    // MultiProvider = puts our 2 shared models at the TOP of the app,
    // so every screen below can read them.
    MultiProvider(
      providers: [
        // ..loadWords() = "create the model, then immediately call GET".
        // So the words start downloading as soon as the app opens.
        ChangeNotifierProvider(create: (_) => WordsModel()..loadWords()),
        ChangeNotifierProvider(create: (_) => FavoritesModel()),
      ],
      child: const DerjaApp(),
    ),
  );
}

class DerjaApp extends StatelessWidget {
  const DerjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Derja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        scaffoldBackgroundColor: AppColors.cream,
        // Messages (SnackBar) float above the bottom bar.
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),
      home: const MainScreen(),
    );
  }
}
