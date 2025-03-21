import 'package:comunicacao_alternativa_app/widgets/profile_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin/admin.dart';
import 'settingsGrid.dart';
import 'students/studentsGrid.dart';
import 'masters/mastersGrid.dart';
import '../../main.dart';
import '../../services/supabase_config.dart';
import '../../notifier/notifier.dart'; // Importe o AvatarProvider

class DashboarAdmindScreen extends StatefulWidget {
  @override
  _DashboarAdmindScreenState createState() => _DashboarAdmindScreenState();
}

class _DashboarAdmindScreenState extends State<DashboarAdmindScreen> {
  AdminModel _adminModel = AdminModel();
  String? userName;
  String? userType;

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Carrega o perfil do usuário ao inicializar
  }

  Future<void> _handleLogout(BuildContext context) async {
    final logout = await _adminModel.logout();
    Navigator.pushNamed(context, '/');
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

  @override
  Widget build(BuildContext context) {
    final user = SupabaseConfig.supabase.auth.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Navegação lateral com o NavigatorRail
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
                print('masters clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MastersgsGrid()),
                );
              }
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentsgsGrid()),
                );
              }
              if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUser()),
                );
              }
              if (index == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsGrid()),
                );
              }
              if (index == 6) {
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
                icon: Icon(Icons.supervisor_account),
                label: Text('Masters'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.supervised_user_circle),
                label: Text('students'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.manage_accounts),
                label: Text('account'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text('logout'),
              ),
            ],
          ),
          // Conteúdo principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                            'Bem-vindo, ${user.email}',
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
