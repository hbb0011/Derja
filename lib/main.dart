
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DerjaApp());
}

class DerjaApp extends StatelessWidget {
  const DerjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Derja',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F1E5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315B3D),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
