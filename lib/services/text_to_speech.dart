import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> setLanguage(String lang) async {
    await flutterTts.setLanguage(lang);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Velocidade da fala
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }
}
