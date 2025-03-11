import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import '/models/student.dart';
import '../../data/students/studentStorage.dart';
import '../../services/supabase_config.dart';

class LoginStudentScreen extends StatelessWidget {
  final StudentStorage _studentStorage = StudentStorage();  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  void _validate(BuildContext context) async{
    final email = _emailController.text;
    final password = _passwordController.text;

    //simple validate
    if(email.isEmpty || password.isEmpty){
      _showErrorDialog(context, 'Email e senha são obrigatórios');
      return;
    }

    if(
      !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      ).hasMatch(email)){
          _showErrorDialog(context, 'Digite um email válido');
          return;
      }
   
    await _login(context, email, password);
  }

  Future<void> _login(BuildContext context, String email, String password) async {
     try {
    // Faz o login do usuário
    final response = await SupabaseConfig.supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Verifica se o e-mail foi confirmado
    final user = response.user;
    if (user != null) {
      Future.microtask(() {
        Navigator.restorablePushReplacementNamed(context, '/dashboardStudent');
      });
    }
  } catch (e) {
    if (e is AuthException) {
      // Verifica se a mensagem de erro contém 'email not confirmed'
      if (e.message.contains('Email not confirmed')) {
        // Permite o login mesmo sem confirmação de e-mail
        Future.microtask(() {
          Navigator.restorablePushReplacementNamed(context, '/dashboardStudent');
        });
      } else {
        print('Erro ao fazer login: ${e.message}');
      }
    } else {
      print('Erro ao fazer login: $e');
    }
  }
  }

  void _showErrorDialog(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
           TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student login')),
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
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email / Registration',
                          hintText: 'aluno@email.com',
                          helperText: 'aluno@email.com',
                          suffixIcon: Icon(Icons.person_2_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          helperText: 'your password here',
                          suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        // keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      Text('Recovery password'),
                      SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => _validate(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.login, size: 20),
                            SizedBox(width: 8),
                            Text('Login'),
                          ],
                        ),
                      ),
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
