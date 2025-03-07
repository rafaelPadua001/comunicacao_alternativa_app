import 'package:flutter/material.dart';
import '../services/text_to_speech.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingningLangague { english, portuguese }

class SetLanguage extends StatefulWidget {
  @override
  _SetLanguageState createState() => _SetLanguageState();
}

class _SetLanguageState extends State<SetLanguage> {
  SingningLangague? _selectedLanguage = SingningLangague.english;

  final TextToSpeech _textToSpeech = TextToSpeech();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    int? languageIndex = prefs.getInt('language') ?? 0; //default 0 to english
    setState(() {
      _selectedLanguage = SingningLangague.values[languageIndex];
    });
  }

  void _savelanguage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('language', _selectedLanguage!.index); //save index to language
  }

  void _submitSelection() {
    _savelanguage();

    String selectedLang =
        _selectedLanguage == SingningLangague.english ? 'en-Us' : 'pt-BR';

    _textToSpeech.setLanguage(selectedLang);
    _textToSpeech.speak(
      'Language changed to ${_selectedLanguage == SingningLangague.english ? 'English' : 'Portuguese'}',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Language Selected'),
          content: Text(
            'You selected ${_selectedLanguage == SingningLangague.english ? 'English' : 'Portuguese'}',
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView(
        children: [
          //First Card
          ExpansionTile(
            title: Text('Set Language o speech'),
            children: [
              ListTile(
                title: const Text('English'),
                leading: Radio<SingningLangague>(
                  value: SingningLangague.english,
                  groupValue: _selectedLanguage,
                  onChanged: (SingningLangague? value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Portuguese (Brazil)'),
                leading: Radio<SingningLangague>(
                  value: SingningLangague.portuguese,
                  groupValue: _selectedLanguage,
                  onChanged: (SingningLangague? value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _submitSelection,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
