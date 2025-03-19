import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
import '../widgets/fullScreenDialog.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  String? _selectedUserType;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkLoginStatus();
  });
  }

  void _checkLoginStatus() async {
    final user = SupabaseConfig.supabase.auth.currentUser;
    
    if (user != null) {
      try {
        final response =
            await SupabaseConfig.supabase
                .from('user_profiles')
                .select('usertype')
                .eq('id', user.id)
                .single();

        if (response.isNotEmpty) {
          final userProfile = response['usertype'];

          switch (userProfile) {
            // Use userProfile diretamente, sem concatenar
            case 'student':
              Future.microtask(() {
                Navigator.restorablePushReplacementNamed(
                  context,
                  '/dashboardStudent',
                );
              });
              break;
            case 'master':
              Future.microtask(() {
                Navigator.restorablePushReplacementNamed(
                  context,
                  '/dashboardMaster',
                );
              });
              break;
            case 'admin':
              print('Redirecionando para o dashboard do administrador');
              Future.microtask(() {
                Navigator.restorablePushReplacementNamed(
                  context,
                  '/dashboardAdmin',
                );
              });
              break;
            default:
              print('Tipo de usuário desconhecido: $userProfile');
              break;
          }
        }
        
      } catch (e) {}
     
    }
    else
        {
          await _fullScreenDialog(context);
          //print(_fullScreenDialog());
        }
  }

  Future<void> _fullScreenDialog(BuildContext context) async {
    if(!mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context){
        return Fullscreendialog();
      }
    );
  }

  void _navigateToLogin() {
    if (_selectedUserType != null) {
      switch (_selectedUserType) {
        case 'Student':
          Navigator.pushNamed(context, '/loginStudent');
          break;
        case 'Master':
          Navigator.pushNamed(context, '/loginMaster');
          break;
        case 'Administrador':
          Navigator.pushNamed(context, '/loginAdmin');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RadioListTile<String>(
              title: Text("Aluno"),
              value: "Student",
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Text("Professor"),
              value: "Master",
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
            ),
            // RadioListTile<String>(
            //   title: Text("Orientador"),
            //   value: "Orientador",
            //   groupValue: _selectedUserType,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedUserType = value;
            //     });
            //   },
            // ),
            RadioListTile<String>(
              title: Text("Administrador"),
              value: "Administrador",
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToLogin,
              child: Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
