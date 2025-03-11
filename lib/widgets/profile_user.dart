import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final user = SupabaseConfig.supabase.auth.currentUser;
  var profileUser = null;

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
        });
        print('Profile user? $profileUser');
      } else {
        print('Nenhum Perfil encontrado para este usuario');
      }
    } catch (e) {
      print('Erro ao buscar perfil do usuario: $e');
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
                      if(profileUser != null) ...[
                        if(profileUser['photourl'] == null)
                          Text('input to upload image')
                        else if(profileUser['photourl'] != null)
                          Text('photo: ${profileUser['photourl']}'),
                        SizedBox(height: 10,),

                        if(profileUser['displayname'] != null)
                          Text('Name: ${profileUser['displayname']}'),
                        if(profileUser['displayname'] == null)
                          Text('aqui vai ser o input do nome'),
                        SizedBox(height: 10,),

                        Text('Email: ${profileUser['email']}'),
                        SizedBox(height: 10,),

                        Text('Tipo de usuario: ${profileUser['usertype']}'),
                        SizedBox(height: 10,),
                        
                        Text('Criado em: ${profileUser['created_at']}'),
                      ]
                      else
                        Text('Carregando Perfil...'),
                    ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
