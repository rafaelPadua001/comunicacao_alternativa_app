import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final user = SupabaseConfig.supabase.auth.currentUser;
  var profileUser = null;
  String? imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() async {
    try {
      final response =
          await SupabaseConfig.supabase
              .from('user_profiles')
              .select()
              .eq('id', user!.id)
              .maybeSingle();

      if (response != null) {
        setState(() {
          profileUser = response;
          imageUrl = profileUser['photoUrl'];
        });
      } else {
        print('Nenhum Perfil encontrado para este usuario');
      }
    } catch (e) {
      print('Erro ao buscar perfil do usuario: $e');
    }
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGalery();
                },
              ),
              ListTile(
                leading: Icon(Icons.cloud_upload),
                title: Text('oneDrive'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromOneDrive();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      // Define o caminho do arquivo no storage
      final filePath =
          '${user!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Converte o XFile em File
      final fileBytes = await image.readAsBytes();

      // Obtém o diretório temporário correto
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');

      await tempFile.writeAsBytes(
        fileBytes,
      ); // Salva os bytes no arquivo temporário

      // Faz o upload da imagem para o Supabase Storage
      final uploadResponse = await SupabaseConfig.supabase.storage
          .from('profile_images')
          .upload(filePath, tempFile);

      // Obtém a URL pública da imagem
      final imageUrlResponse = SupabaseConfig.supabase.storage
          .from('profile_images')
          .getPublicUrl(filePath);

      // Atualiza o perfil do usuário com a nova URL da imagem
      final updateResponse = await SupabaseConfig.supabase
          .from('user_profiles')
          .update({'photourl': imageUrlResponse})
          .eq('id', user!.id);

      setState(() {
        imageUrl = imageUrlResponse;
      });

      // Exclui o arquivo temporário após o upload
      await tempFile.delete();
    } catch (e) {
      print('Erro durante o upload: $e');
    }
  }

  Future<void> _pickImageFromGalery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await _uploadImage(image);
      _imageFile = File(image.path);
    }
  }

  Future<void> _pickImageFromOneDrive() async {
    print('selecionar imagem do OneDrive');
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      print('Imagem capturada da camera: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile User')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4, // Sombra para destacar o card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (profileUser != null) ...[
                        ExpansionTile(
                          title: Text('Profile photo'),
                          children: [
                            if (_imageFile != null) ...[
                              Image.file(
                                _imageFile!,
                              ), // Exibe a prévia da imagem
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _showImageSourceBottomSheet(context);
                                },
                                child: Text('Mudar Imagem'),
                              ),
                            ] else if (profileUser != null &&
                                profileUser['photourl'] != null) ...[
                              Image.network(
                                profileUser['photourl'],
                              ), // Exibe a imagem do perfil se houver
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _showImageSourceBottomSheet(context);
                                },
                                child: Text('Alterar Imagem'),
                              ),
                            ] else ...[
                              ElevatedButton(
                                onPressed: () {
                                  _showImageSourceBottomSheet(context);
                                },
                                child: Text('Upload Imagem'),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 10),

                        // Accordion para o nome
                        ExpansionTile(
                          title: Text('Personal'),
                          children: [
                            if (profileUser['displayname'] != null) ...[
                              Text('Nome: ${profileUser['displayname']}'),
                              SizedBox(height: 10),
                              Text('Email: ${profileUser['email']}'),
                              Text(
                                'Tipo de usuário: ${profileUser['usertype']}',
                              ),
                            ] else
                              Text('Aqui vai ser o input do nome'),
                            Text('Email: ${profileUser['email']}'),
                            Text('Tipo de usuário: ${profileUser['usertype']}'),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Accordion para a data de criação
                        ExpansionTile(
                          title: Text('Criado em'),
                          children: [
                            Text('Criado em: ${profileUser['created_at']}'),
                          ],
                        ),
                      ] else
                        Text('Carregando Perfil...'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
