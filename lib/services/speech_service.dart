
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    await _tts.stop();

    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    await _tts.setLanguage('ar-TN');

    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
