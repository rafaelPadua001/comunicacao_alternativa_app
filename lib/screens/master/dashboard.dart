import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comunicacao_alternativa_app/models/admin/admin.dart';
import '../../services/supabase_config.dart';
import '../../main.dart';
import '../../widgets/profile_user.dart';
import 'settingsGrid.dart';
import '../../notifier/notifier.dart'; // Importe o AvatarProvider

class DashboarMasterScreen extends StatefulWidget {
  @override
  _DashboarMasterScreenState createState() => _DashboarMasterScreenState();
}

class _DashboarMasterScreenState extends State<DashboarMasterScreen> {
  String? userName;
  String? userType;
  AdminModel _adminModel = AdminModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkEmailVerification();
      fetchUserProfile(); // Carrega o perfil do usuário ao inicializar
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
                  MaterialPageRoute(builder: (context) => SettingsGrid()),
                );
              }
              if (index == 4) {
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
                label: Text(
                  userName ?? 'Carregando...',
                ), // Exibe o nome do usuário
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
                      ? Text(
                        'Nenhum usuário logado',
                      ) // Caso nenhum usuário esteja logado
                      : Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Alinha ao topo
                        children: [
                          SizedBox(
                            height: 20,
                          ), // Adiciona um espaço no topo da Column
                          Text(
                            'Bem-vindo, ${userType ?? userName}',
                          ), // Exibe o e-mail do usuário
                          SizedBox(height: 20),
                        ],
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
