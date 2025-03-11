import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
// import '/models/student.dart';
// import '../routes/student.routes.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  String? _selectedUserType;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
           print(userProfile);
         switch (userProfile) { // Use userProfile diretamente, sem concatenar
    case 'student':
      print('Redirecionando para o dashboard do estudante');
      Future.microtask(() {
        Navigator.restorablePushReplacementNamed(
          context,
          '/dashboardStudent',
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
      // Usuário já logado
      // Future.microtask(() {
      //   print(user);
      //   Navigator.restorablePushReplacementNamed(context, '/dashboardAdmin');
      // });
    }
  }

  void _navigateToLogin() {
    if (_selectedUserType != null) {
      switch (_selectedUserType) {
        case 'Student':
          Navigator.pushNamed(context, '/loginStudent');
          break;
        case 'Professor':
          Navigator.pushNamed(context, '/loginProfessor');
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
              value: "Professor",
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
