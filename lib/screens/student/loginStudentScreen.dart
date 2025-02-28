import 'package:flutter/material.dart';
import '/models/student.dart';

class LoginStudentScreen extends StatelessWidget {
  final _registrationController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _registrationController,
              decoration: InputDecoration(
                labelText: 'Registration',
                suffixIcon: Icon(Icons.person)),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: Icon(Icons.lock),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // final student = Student(
                //   name: _nameController.text,
                //   age: int.parse(_ageController.text),
                //   registration: _registrationController.text,
                // );
                //addStudent(student);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    );
  }
}
