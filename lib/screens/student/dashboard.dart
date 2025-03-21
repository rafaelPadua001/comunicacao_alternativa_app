import 'package:comunicacao_alternativa_app/models/admin/admin.dart';
import 'package:comunicacao_alternativa_app/screens/admin/pictograms/addPictogram.dart';
import 'package:flutter/material.dart';
import '../../services/supabase_config.dart';
// import 'studentGrid.dart';
import '../../main.dart';
import '../../widgets/profile_user.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../notifier/notifier.dart';

class DashboarStudentScreen extends StatefulWidget {
  @override
  _DashboarStudentScreenState createState() => _DashboarStudentScreenState();
}

class _DashboarStudentScreenState extends State<DashboarStudentScreen> {
  String? userName;
  String? avatarImage;
  String? userType;
  Map<String, dynamic>? profileUser;
  AdminModel _adminModel = AdminModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkEmailVerification();
      fetchUserProfile(); // Fetch user profile data when the widget initializes
    });
  }

  void checkEmailVerification() async {
    final user = SupabaseConfig.supabase.auth.currentUser;

    if (user != null) {
      try {
        if (user.emailConfirmedAt == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Por favor, verifique seu e-mail para continuar.',
                ),
                duration: Duration(seconds: 10),
              ),
            );
          });
        }
      } catch (e) {
        print('Erro ao consultar o Supabase: $e');
      }
    }
  }

  Future<void> fetchUserProfile() async {
    final user = SupabaseConfig.supabase.auth.currentUser;

    await checkPasswordChange();
    if (user != null) {
      try {
        final getProfileUser =
            await SupabaseConfig.supabase
                .from('user_profiles')
                .select()
                .eq('id', user.id)
                .maybeSingle();

        if (getProfileUser != null) {
          final avatarProvider = Provider.of<AvatarProvider>(
            context,
            listen: false,
          );
          setState(() {
            userName = getProfileUser['displayname'];
            userType = getProfileUser['usertype'];
          });
          avatarProvider.updateAvatarImage(getProfileUser['photourl']);
        } else {
          print('No profile found for the user.');
        }
      } catch (e) {
        print('Error fetching profile: $e');
      }
    }
  }

   Future<void> checkPasswordChange() async {
    final user = SupabaseConfig.supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await SupabaseConfig.supabase
            .from('user_profiles')
            .select('created_at, updated_at')
            .eq('id', user.id)
            .maybeSingle();

        if (response != null) {
          final createdAt = DateTime.parse(response['created_at']);
          final lastLogin = DateTime.parse(response['updated_at']);

          if (lastLogin.isAtSameMomentAs(createdAt)) {
            print('O usuário NÃO alterou a senha desde o primeiro login.');
            await _showDialog(context);
            // Navigator.pushNamed(context, '/changePassword');
          } else {
            print('O usuário alterou a senha após o primeiro login.');
          }
        } else {
          print('Perfil do usuário não encontrado.');
        }
      } catch (e) {
        print('Erro ao verificar alteração de senha: $e');
      }
    }
  }

 Future<void> _showDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alterar Senha'),
        content: Text('Após o primeiro acesso você deve trocar sua senha...'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Fecha o dialog
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              // Ação ao pressionar o botão "OK"
              print('Botão OK pressionado');
              Navigator.of(context).pop();
            },
            child: Text('Trocar senha'),
          ),
        ],
      );
    },
  );
}
  Future<void> _handleLogout(BuildContext context) async {
    final logout = await _adminModel.logout();

    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseConfig.supabase.auth.currentUser;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) async {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUser()),
                );
              }
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPictogram()),
                );
              }
              if (index == 4) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingsGrid()),
                // );
              }
              if (index == 5) {
                final logoutResponse = await _handleLogout(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Consumer<AvatarProvider>(
                  builder: (context, avatarProvider, child) {
                    return CircleAvatar(
                      backgroundImage:
                          avatarProvider.avatarImage != null
                              ? NetworkImage(avatarProvider.avatarImage!)
                              : null,
                      child:
                          avatarProvider.avatarImage == null
                              ? Icon(Icons.person)
                              : null,
                      radius: 28,
                    );
                  },
                ),
                label: Text('${userName}'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_3),
                label: Text('account'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.image),
                label: Text('pictograms'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text('logout'),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  user == null
                      ? Text('Nenhum usuário logado')
                      : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text('Bem-vindo, ${userType ?? userName}'),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
