import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPictogram extends StatefulWidget {
  @override
  _AddPictogramState createState() => _AddPictogramState();
}

class _AddPictogramState extends State<AddPictogram> {
  File? _image;
  final TextEditingController _labelController = TextEditingController();
  String? _selectedCategory;
  final List<String> categories = ["Animals", "Objects", "People", "Nature"];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _savePictogram() {
    if (_image != null && _labelController.text.isNotEmpty && _selectedCategory != null) {
      print("Pictogram saved: ${_labelController.text}, Category: $_selectedCategory");
    } else {
      print("Please select an image, enter a name, and choose a category.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Pictogram")),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(32),
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
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
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
        ),
      ),
    );
  }
}
