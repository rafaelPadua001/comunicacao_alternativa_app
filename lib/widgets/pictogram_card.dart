import 'dart:io';
import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/adapters.dart';
import '../data/pictogramStorage.dart';
import '../screens/addPictogramScreen.dart';
import '../screens/userselectionScreen.dart';
import '../models/pictogram.dart';
import '../models/pictograms/pictogram.dart' as adminPictogram;
import '../models/student.dart';
import '../models/admin/admin.dart';
import '../widgets/set_language.dart';

class PictogramCard extends StatefulWidget {
  @override
  _PictogramCardState createState() => _PictogramCardState();
}

class _PictogramCardState extends State<PictogramCard> {
  final Pictogramstorage _storage = Pictogramstorage();
  final FlutterTts flutterTts = FlutterTts()..setLanguage('en-US');
  final AdminModel _adminModel = AdminModel();

  List<Pictogram> _hivePictograms = [];
  List<bool> _selectedItems = [];
  List<Pictogram> _supabasePictograms = [];

  // Lista de pictogramas locais
  final List<Pictogram> pictograms = [
    Pictogram(
      imagePath: 'assets/image/apple.png',
      label: 'apple',
      category: 'fruit',
    ),
    Pictogram(
      imagePath: 'assets/image/grape.png',
      label: 'grape',
      category: 'fruit',
    ),
    Pictogram(
      imagePath: 'assets/image/orange.png',
      label: 'orange',
      category: 'fruit',
    ),
    Pictogram(
      imagePath: 'assets/image/watter.png',
      label: 'water',
      category: 'drink',
    ),
    Pictogram(
      imagePath: 'assets/image/cat.png',
      label: 'cat',
      category: 'animal',
    ),
    Pictogram(
      imagePath: 'assets/image/dog.png',
      label: 'dog',
      category: 'animal',
    ),
    Pictogram(
      imagePath: 'assets/image/dinosaur.png',
      label: 'dinosaur',
      category: 'animal',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPictograms();
  }

  // Função para carregar pictogramas do Hive
  Future<void> _loadPictograms() async {
    try {
      final hivePictograms =
          await _storage.getPictograms(); // Pictogramas do Hive

      setState(() {
        _hivePictograms = List<Pictogram>.from(hivePictograms);
      });

      await _loadSupabasePictograms(); // Carregar pictogramas do Supabase
    } catch (e) {
      print("Erro ao carregar pictogramas: $e");
    }
  }

  //load pictograms supabase
  Future<void> _loadSupabasePictograms() async {
    try {
      final response = await SupabaseConfig.supabase
          .from('pictograms_table')
          .select('*');

      if (response != null) {
        List<Pictogram> supabasePictograms =
            response.map<Pictogram>((pictogramData) {
              return Pictogram(
                imagePath:
                    pictogramData['imageUrl'], // URL da imagem no Supabase
                label: pictogramData['label'],
                category: pictogramData['category'],
                isLocal:
                    false, // Para diferenciar os pictogramas locais dos remotos
              );
            }).toList();

        setState(() {
          _supabasePictograms = supabasePictograms;
          _selectedItems = List.filled(
            pictograms.length +
                _hivePictograms.length +
                _supabasePictograms.length,
            false,
          );
        });
      }
    } catch (e) {
      print("Erro ao carregar pictogramas do Supabase: $e");
    }
  }

  // Função para falar o texto
  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  //Função para captura do tipo de usuario para realizar logou
  Future<void> _handleLogout() async {
    final user = SupabaseConfig.supabase.auth.currentUser;

    if (user != null) {
      print("Usuário logado: ${user.email}");

      try {
        // Buscar o tipo de usuário na tabela 'user_profiles'
        final response =
            await SupabaseConfig.supabase
                .from('user_profiles')
                .select('usertype') // ALTERADO para minúsculo
                .eq('id', user.id)
                .maybeSingle();

        if (response != null && response.containsKey('usertype')) {
          final String userType = response['usertype'];
          print("Tipo de usuário: $userType");

          // Logout no Supabase
          await SupabaseConfig.supabase.auth.signOut();
          print("Logout realizado!");

          // Redirecionamento correto
          switch (userType) {
            case 'admin':
              Navigator.pushReplacementNamed(context, '/loginAdmin');
              break;
            case 'student':
              Navigator.pushReplacementNamed(context, '/loginStudent');
              break;
            case 'professor':
              Navigator.pushReplacementNamed(context, '/loginProfessor');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/userSelection');
              break;
          }
        } else {
          print("Erro: campo 'userType' não encontrado.");
        }
      } catch (e) {
        print("Erro ao buscar usuário no Supabase: $e");
      }
    } else {
      print("Nenhum usuário logado.");
    }
  }

  // Função para agrupar pictogramas por categoria
  Map<String, List<Pictogram>> _groupPictogramsByCategory(
    List<Pictogram> pictograms,
  ) {
    Map<String, List<Pictogram>> groupedPictograms = {};

    for (var pictogram in pictograms) {
      if (!groupedPictograms.containsKey(pictogram.category)) {
        groupedPictograms[pictogram.category] = [];
      }
      groupedPictograms[pictogram.category]!.add(pictogram);
    }

    return groupedPictograms;
  }

  // Função para construir a lista de pictogramas por categoria
  Widget _buildPictogramList(List<Pictogram> allPictograms) {
    final groupedPictograms = _groupPictogramsByCategory(allPictograms);

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: groupedPictograms.length,
      itemBuilder: (context, index) {
        final category = groupedPictograms.keys.elementAt(index);
        final pictogramsInCategory = groupedPictograms[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                category,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Desabilita o scroll interno
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: pictogramsInCategory.length,
              itemBuilder: (context, index) {
                final pictogram = pictogramsInCategory[index];

                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedItems[allPictograms.indexOf(pictogram)] = true;
                    });

                    await _speak(pictogram.label);

                    await Future.delayed(Duration(seconds: 1));

                    setState(() {
                      _selectedItems[allPictograms.indexOf(pictogram)] = false;
                    });
                  },
                  child: Card(
                    color:
                        _selectedItems[allPictograms.indexOf(pictogram)]
                            ? Colors.green
                            : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        pictogram.isLocal
                            ? Image.file(
                              File(pictogram.imagePath),
                              height: 50,
                            ) // Para imagens locais
                            : pictogram.imagePath.startsWith('http')
                            ? Image.network(
                              pictogram
                                  .imagePath, // Para imagens remotas (URLs)
                              height: 50,
                            )
                            : Image.asset(
                              pictogram.imagePath,
                              height: 50,
                            ), // Para imagens embutidas
                        SizedBox(height: 10),
                        Text(
                          pictogram.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Combina as listas de pictogramas locais e do Hive
    final allPictograms = [
      ...pictograms,
      ..._hivePictograms,
      ..._supabasePictograms,
    ];

    // Verifica se a lista de pictogramas está vazia
    if (allPictograms.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Comunicação Alternativa")),
        body: Center(
          child:
              CircularProgressIndicator(), // Exibe um carregamento enquanto não há pictogramas
        ),
      );
    }

    // Verifica se _selectedItems foi inicializada corretamente
    if (_selectedItems.length != allPictograms.length) {
      return Scaffold(
        appBar: AppBar(title: Text("Comunicação Alternativa")),
        body: Center(
          child:
              CircularProgressIndicator(), // Exibe um carregamento enquanto _selectedItems não está pronta
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Comunicação Alternativa"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) async {
              if (result == 'add_image') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPictogramScreen()),
                ).then((_) => _loadPictograms()); // Atualiza após adicionar
              }
              if (result == 'dashboard') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSelectionScreen(),
                  ),
                );
              }
              if (result == 'setLanguage') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetLanguage()),
                );
              }
              if (result == 'logout') {
                await _handleLogout();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'add_image',
                    child: Row(
                      children: [
                        Icon(Icons.add_photo_alternate_rounded),
                        SizedBox(width: 10),
                        Text('Add Image'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'dashboard',
                    child: Row(
                      children: [
                        Icon(Icons.dashboard),
                        SizedBox(width: 10),
                        Text('Dashboard'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'setLanguage',
                    child: Row(
                      children: [
                        Icon(Icons.settings_voice),
                        SizedBox(width: 10),
                        Text('set Language'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text('logout'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: _buildPictogramList(allPictograms))],
      ),
    );
  }
}
