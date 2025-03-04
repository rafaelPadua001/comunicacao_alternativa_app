import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../data/pictograms/pictogramStorage.dart' as adminPictogram;
import '../../../data/pictogramStorage.dart' as localPictogram;
import '../../../models/pictogram.dart';

class AddPictogram extends StatefulWidget {
  @override
  _AddPictogramState createState() => _AddPictogramState();
}

class _AddPictogramState extends State<AddPictogram> {
  File? _image;
  final TextEditingController _labelController = TextEditingController();
  String? _selectedCategory;
  final List<String> categories = [
    "Animals",
    "Objects",
    "People",
    "Nature",
    "Fruit",
    "Drink",
  ];

  bool _isUploading = false;
  bool _isLoading = true;
  bool _isSelecting = false;
  Set<int> _selectedIndex = {};

  List<Map<String, dynamic>> _allPictograms = [];
  final localPictogramStorage = localPictogram.Pictogramstorage();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _savePictogram() async {
    if (_image == null ||
        _labelController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preencha todos os campos e selecione uma imagem"),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Upload da imagem para o Supabase Storage
      final String? imageUrl = await adminPictogram
          .PictogramStorage.uploadImage(_image!);
      if (imageUrl == null) throw Exception("Falha no upload da imagem");

      // Salva os dados no banco
      final bool isSaved = await adminPictogram.PictogramStorage.savePictogram(
        _labelController.text,
        _selectedCategory!,
        imageUrl,
      );

      if (isSaved) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Pictograma salvo!")));
        _loadPictograms();
        setState(() {
          _image = null;
          _labelController.clear();
          _selectedCategory = null;
          _isUploading = false;
        });
      } else {
        throw Exception("Erro ao salvar no banco");
      }
    } catch (error) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $error")));
    }
  }

  void _toggleSelectionMode(int index) {
    setState(() {
      if (_isSelecting) {
        if (_selectedIndex.contains(index)) {
          _selectedIndex.remove(index);
          if (_selectedIndex.isEmpty) {
            _isSelecting = false;
          }
        } else {
          _selectedIndex.add(index);
        }
      }
    });
  }

  void _startSelection(int index) {
    setState(() {
      _isSelecting = true;
      _selectedIndex.add(index);
    });
  }

  void  _deleteSelectedItems(Set<int> index){
    print(index);
  }
  Future<void> _loadPictograms() async {
    setState(() => _isLoading = true);
    try {
      // Carregar pictogramas locais
      List<Pictogram> localPictograms =
          await localPictogramStorage.getPictograms();

      // Converter os pictogramas locais de List<Pictogram> para List<Map<String, dynamic>>
      List<Map<String, dynamic>> localPictogramsMap =
          localPictograms.map((pictogram) {
            return {
              "isLocal": true,
              "imagePath":
                  pictogram.imagePath, // Verifique se esse caminho está correto
              "label": pictogram.label,
            };
          }).toList();

      // Carregar pictogramas do Supabase
      var supabasePictograms =
          await adminPictogram.PictogramStorage.getPictograms();
      print(
        "Pictogramas do Supabase: $supabasePictograms",
      ); // Verifique o tipo real da resposta

      // Certifique-se de que a resposta está no formato esperado
      List<Map<String, dynamic>> supabasePictogramsMap =
          supabasePictograms.map((pictogram) {
            return {
              "isLocal": false,
              "imageUrl":
                  pictogram
                      .imageUrl, // Garanta que você está acessando a chave correta
              "label": pictogram.label,
            };
          }).toList();

      setState(() {
        _allPictograms = [];
        _allPictograms.addAll(localPictogramsMap);
        _allPictograms.addAll(supabasePictogramsMap);
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar pictogramas: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPictograms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pictograms")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ExpansionTile(
                  title: Text(
                    "Add Pictogram",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _image != null
                              ? Image.file(_image!, height: 200)
                              : Text(
                                'Select Image',
                                style: TextStyle(fontSize: 16),
                              ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.file_upload, size: 24),
                                SizedBox(width: 8),
                                Text("Upload Image"),
                              ],
                            ),
                          ),
                          if (_image != null) ...[
                            SizedBox(height: 10),
                            TextField(
                              controller: _labelController,
                              decoration: InputDecoration(
                                labelText: "Pictogram Name",
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButton<String>(
                              value: _selectedCategory,
                              hint: Text("Select a category"),
                              isExpanded: true,
                              items:
                                  categories.map((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                              onChanged: (String? newCategory) {
                                setState(() {
                                  _selectedCategory = newCategory;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _savePictogram,
                              child: Text('Save'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                elevation: 4,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Pictograms",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedIndex.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _deleteSelectedItems(_selectedIndex);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child:
                          _isLoading
                              ? CircularProgressIndicator()
                              : _allPictograms.isEmpty
                              ? Text("Nenhum pictograma encontrado.")
                              : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children:
                                    _allPictograms.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      var pictogram = entry.value;
                                      bool isSelected = _selectedIndex.contains(
                                        index,
                                      );

                                      return GestureDetector(
                                        onTap:
                                            () => _toggleSelectionMode(index),
                                        onLongPress:
                                            () => _startSelection(index),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border:
                                                    isSelected
                                                        ? Border.all(
                                                          color: Colors.blue,
                                                          width: 3.0,
                                                        )
                                                        : null,
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child:
                                                  pictogram['isLocal']
                                                      ? Image.file(
                                                        File(
                                                          pictogram['imagePath'],
                                                        ),
                                                        height: 50,
                                                      )
                                                      : Image.network(
                                                        pictogram['imageUrl'],
                                                        height: 50,
                                                      ),
                                            ),

                                            Text(pictogram['label']),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
