import 'package:flutter/material.dart';
import '/models/student.dart';

class LoginStudentScreen extends StatelessWidget {
  final _registrationController = TextEditingController();
  final _passwordController = TextEditingController();

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
                        controller: _registrationController,
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
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      Text('Recovery password'),
                      SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
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
