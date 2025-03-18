import '../data/pictogramStorage.dart';
import '../widgets/pictogram_card.dart' as widgetPictogram;
import '../models/pictogram.dart' as modelPictogram;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AddPictogramScreen extends StatefulWidget {
  @override
  _AddPictogramScreenState createState() => _AddPictogramScreenState();
}

class _AddPictogramScreenState extends State<AddPictogramScreen> {
  File? _image;
  final TextEditingController _labelController = TextEditingController();
  final storage = Pictogramstorage();

  String? _selectedCategory;
  List<String> categories = [
    'fruit',
    'animal',
    'Objetos',
    'eat',
    'drink',
    'people',
  ];

  // Função para selecionar imagem
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePictogram() async {
    // Verifica se algum campo está vazio e exibe a mensagem de erro
    if (_image == null ||
        _labelController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos antes de salvar!')),
      );
      return;
    }

    try {
      // Obtém o diretório de documentos do aplicativo
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = path.join(
        directory.path,
        path.basename(_image!.path),
      );

      // Copia a imagem para o novo diretório
      final File newImage = await _image!.copy(newPath);

      // Cria o Pictogram com os dados fornecidos
      final pictogram = modelPictogram.Pictogram(
        imagePath: newPath, // Caminho da imagem salva
        label: _labelController.text, // Rótulo fornecido pelo usuário
        category: _selectedCategory!,
        isLocal: true, // Categoria selecionada
      );
      //await storage.clearPictograms();
      // Salva o pictograma usando o armazenamento
      await storage.savePictogram(pictogram);

      // Exibe as informações no console para verificação
      print('Imagem salva em: $newPath');
      print('Nome do Pictograma: ${_labelController.text}');
      print('Categoria: $_selectedCategory');

      // Exibe uma mensagem de sucesso para o usuário
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pictograma salvo com sucesso!')));

      // Fecha a tela após salvar
      Navigator.of(context).pop();
    } catch (e) {
      // Se ocorrer um erro durante o processo, exibe uma mensagem de erro
      print('Erro ao salvar pictograma: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar o pictograma.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New pictogram')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Exibe a imagem selecionada ou o Placeholder
            _image != null
                ? Image.file(_image!, height: 150)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Select Image:'),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                  ],
                ),
            SizedBox(height: 10),
            // Exibe o TextField apenas quando a imagem for selecionada
            if (_image != null)
              Column(
                children: [
                  TextField(
                    controller: _labelController,
                    decoration: InputDecoration(
                      labelText: "have a name to pictogram",
                      suffix: Icon(Icons.description_outlined),
                      hintText: 'select a name to show',
                      helperText: 'dog, love, cat, meat, popcorn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_image != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ), // Adiciona o padding ao redor do botão
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ), // Borda de 2px e cor azul
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Bordas arredondadas
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: Text("Select a category"),
                        isExpanded:
                            true, // Para ocupar toda a largura disponível
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
                        underline:
                            Container(), // Remove a linha padrão do dropdown
                      ),
                    ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _savePictogram,
                    child: Text('save'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
