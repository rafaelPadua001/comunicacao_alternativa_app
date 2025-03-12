import 'package:flutter/material.dart';
import '../../models/master/master.dart';
import '../../data/masters/masterStorage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterMaster extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterMaster> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final MaskTextInputFormatter phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+55 (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Master')),
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
                        labelText: 'Master Full name',
                        helperText:
                            'John Da Silva, Maria do carmo, Rachel Bom Sucesso',
                        hintText: 'Enter master full name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter some name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.email_outlined),
                        labelText: 'Master E-mail',
                        helperText: 'master@email.com',
                        hintText: 'Enter master e-mail',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter some e-mail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.phone_android),
                        labelText: 'Master phone',
                        helperText: '(99) 99999-9999',
                        hintText: 'Enter master phone number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Plase enter phone number';
                        }
                        if(!phoneMaskFormatter.isFill()){
                          return 'please enter a valid phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [phoneMaskFormatter],
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
                            Master master = Master(
                              fullName: _fullNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              phone: _phoneController.text,
                            );

                            String? result = await MasterStorage.registerUser(master);

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
