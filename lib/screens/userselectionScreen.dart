import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:flutter/material.dart';
import '/models/student.dart';
import '../routes/student.routes.dart';
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
  print('usuario logado: $user' );
  if (user != null) {
    // Usuário já logado
    Future.microtask(() {
      print(user);
      Navigator.restorablePushReplacementNamed(context, '/dashboardAdmin');
    });
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
