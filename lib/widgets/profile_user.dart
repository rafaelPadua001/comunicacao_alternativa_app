import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final user = SupabaseConfig.supabase.auth.currentUser;
  var profileUser = null;
  String? imageUrl;
  File? _imageFile;
  bool isEditingName = false;
  bool isEditingEmail = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
          _nameController.text = profileUser['displayname'] ?? '';
          _emailController.text = profileUser['email'] ?? '';
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

  Future<void> _updateProfile() async {
    try {
      // Atualiza a tabela user_profiles
      final updateProfileResponse = await SupabaseConfig.supabase
          .from('user_profiles')
          .update({
            'displayname': _nameController.text,
            'email': _emailController.text,
          })
          .eq('id', user!.id);

      if (updateProfileResponse == null) {
        // Atualiza o autenticador (usuário)
        final updateAuthResponse = await SupabaseConfig.supabase.auth
            .updateUser(
              UserAttributes(
                // Atualiza o email no autenticador
                email: _emailController.text,
                data: {
                  'display_name':
                      _nameController
                          .text, // Atualiza o displayname no autenticador
                },
              ),
            );

        if (updateAuthResponse.user != null) {
          // Atualiza o estado local
          setState(() {
            profileUser['displayname'] = _nameController.text;
            profileUser['email'] = _emailController.text;
          });
          print('Perfil e autenticador atualizados com sucesso!');
        } else {
          print('Erro ao atualizar o autenticador.');
        }
      } else {
        print('Erro ao atualizar o perfil.');
      }
    } catch (e) {
      print('Erro durante a atualização do perfil e autenticador: $e');
    }
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      // Define o caminho do arquivo no storage
      final filePath =
          '${user!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Converte o XFile em File
      final fileBytes = await image.readAsBytes();
      final tempDir =
          await Directory.systemTemp.create(); // Cria o diretório temporário
      final tempFile = File(
        '${tempDir.path}/temp_image.jpg',
      ); // Cria um arquivo temporário
      await tempFile.writeAsBytes(
        fileBytes,
      ); // Salva os bytes no arquivo temporário

      // Faz o upload da imagem para o Supabase Storage
      final uploadResponse = await SupabaseConfig.supabase.storage
          .from('profile_images')
          .upload(filePath, tempFile);

      // Gera uma URL assinada válida por 1 hora (3600 segundos)
      final signedUrlResponse = await SupabaseConfig.supabase.storage
          .from('profile_images')
          .createSignedUrl(filePath, 3600);

      // Atualiza o perfil do usuário com a nova URL assinada da imagem
      final updateResponse = await SupabaseConfig.supabase
          .from('user_profiles')
          .update({'photourl': signedUrlResponse})
          .eq('id', user!.id);

      setState(() {
        imageUrl = signedUrlResponse;
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
                        SizedBox(height: 20),

                        // Accordion para o nome
                        ExpansionTile(
                          title: Text('Personal'),
                          children: [
                            if (profileUser['displayname'] != null) ...[
                              Row(
                                children: [
                                  if (!isEditingName)
                                    Text('Nome: ${profileUser['displayname']}'),
                                  if (isEditingName)
                                    Expanded(
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          labelText: 'Nome',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        isEditingName = !isEditingName;
                                        if (!isEditingName) {
                                          // Salvar o valor do nome (aqui você pode adicionar lógica para salvar no backend)
                                          profileUser['displayname'] =
                                              _nameController.text;
                                        }
                                      });
                                      if (!isEditingName) {
                                        await _updateProfile();
                                      }
                                    },
                                    child: Text(
                                      isEditingName ? 'Save' : 'Edit',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  if (!isEditingEmail)
                                    Text('Email: ${profileUser['email']}'),
                                  if (isEditingEmail)
                                    Expanded(
                                      child: TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  TextButton(
                                    onPressed: (() async {
                                      setState(() {
                                        isEditingEmail = !isEditingEmail;
                                        if (!isEditingEmail) {
                                          profileUser['email'] =
                                              _emailController.text;
                                        }
                                      });
                                      if (!isEditingEmail) {
                                        await _updateProfile();
                                      }
                                    }),
                                    child: Text(
                                      isEditingEmail ? 'save' : 'Edit',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Tipo de usuário: ${profileUser['usertype']}',
                                  ),
                                ],
                              ),
                            ] else
                              Column(
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText:
                                          '${profileUser['displayName']}',
                                      hintText: 'full name',
                                      helperText: 'Jõao da Silva',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: '${profileUser['email']}',
                                      hintText: 'email',
                                      helperText: 'email@email.com',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (() {
                                      setState(() async {
                                        isEditingName = !isEditingName;
                                        if (!isEditingName) {
                                          profileUser['diplayname'] =
                                              _nameController.text;
                                          await _updateProfile();
                                        }
                                        // profileUser['diplayname'] = _nameController.text;
                                      });
                                    }),
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
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
