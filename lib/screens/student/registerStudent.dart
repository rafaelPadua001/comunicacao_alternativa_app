import 'package:flutter/material.dart';
import '../../models/student/student.dart';
import '../../data/students/studentStorage.dart';

class RegisterStudent extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Student')),
      body: Padding(
        padding: EdgeInsets.all(0.6),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.person_outline),
                        labelText: 'Student Full name',
                        helperText:
                            'John Da Silva, Maria do carmo, Rachel Bom Sucesso',
                        hintText: 'Enter student full name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter some name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.email_outlined),
                        labelText: 'Student E-mail',
                        helperText: 'Student@email.com',
                        hintText: 'Enter Student e-mail',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter some e-mail';
                        }
                        return null;
                      },
                    ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     suffixIcon: Icon(Icons.password),
                    //     labelText: 'Student password',
                    //     helperText: 'you password',
                    //     hintText: 'Enter Student password',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   obscureText: true,
                    //   validator: (String? value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Plase enter some e-mail';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //process data
                            Student student = Student(
                              fullName: _fullNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text
                            );

                            String? result = await StudentStorage.registerUser(student);

                            if (result == null) {
                              // Sucesso no registro
                              print("Aluno registrado com sucesso!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Aluno Cadastrado com sucesso !')
                              ),
                              );
                            } else {
                              // Falha no registro
                              print(result);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao cadastrar novo aluno $result'),
                                ),
                              );
                            }
                                                    
                            
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
