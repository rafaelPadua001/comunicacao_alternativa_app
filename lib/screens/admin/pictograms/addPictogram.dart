import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../data/pictograms/pictogramStorage.dart';
import '../../../services/supabase_config.dart';

class AddPictogram extends StatefulWidget {
  @override
  _AddPictogramState createState() => _AddPictogramState();
}

class _AddPictogramState extends State<AddPictogram> {
  File? _image;
  final TextEditingController _labelController = TextEditingController();
  String? _selectedCategory;
  final List<String> categories = ["Animals", "Objects", "People", "Nature", "Fruit", "Drink"];
  final PictogramStorage _pictogramStorage = PictogramStorage();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _savePictogram() async {
     if (_image == null || _labelController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos e selecione uma imagem")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1️⃣ Faz upload da imagem para o Supabase Storage
      final String? imageUrl = await PictogramStorage.uploadImage(_image!);
      if (imageUrl == null) throw Exception("Falha no upload da imagem");

      // 2️⃣ Salva os dados no banco
      final bool isSaved = await PictogramStorage.savePictogram(
        _labelController.text,
        _selectedCategory!,
        imageUrl,
      );

      if (isSaved) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pictograma salvo!")));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pictograms")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                            : Text('Select Image', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
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
                            decoration: InputDecoration(labelText: "Pictogram Name"),
                          ),
                          SizedBox(height: 10),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            hint: Text("Select a category"),
                            isExpanded: true,
                            items: categories.map((String category) {
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
          ],
        ),
      ),
    );
  }
}
