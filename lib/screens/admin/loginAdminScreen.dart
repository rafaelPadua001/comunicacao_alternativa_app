import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/admin/admin.dart';

class LoginAdminScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AdminModel _adminModel = AdminModel();
  void _validate(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    //Simple validate
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Email e senha são obrigatórios");
      return;
    }

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      _showErrorDialog(context, "Digite um email válido");
      return;
    }

    await _login(context, email, password);
  }

  Future<void> _login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      //Auth with firebase
      await _adminModel.loginWithEmailPassword(email, password);
      //send next view
      Navigator.pushReplacementNamed(context, '/dashboardAdmin');
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message ?? "Erro ao fazer login");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Error'),
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
      appBar: AppBar(title: Text('Admin login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4, // Sombra para destacar o card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Bordas arredondadas
                ),
                child: Padding(
                  padding: EdgeInsets.all(16), // Espaçamento interno
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          suffixIcon: Icon(Icons.person),
                          helperText: 'user@email.com',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10), // Espaço entre os campos
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: Icon(Icons.lock),
                          helperText: 'your password here',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20), // Espaço antes do botão
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
