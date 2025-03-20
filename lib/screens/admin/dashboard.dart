import '../../models/admin/admin.dart';
import 'settingsGrid.dart';
import 'students/studentsGrid.dart';
import 'masters/mastersGrid.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../../services/supabase_config.dart';

class DashboarAdmindScreen extends StatelessWidget {
  AdminModel _adminModel = AdminModel();
  
  Future<void> _handleLogout(BuildContext context) async {
    final logout = await _adminModel.logout();

    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    // Obter o usuário logado
    final user = SupabaseConfig.supabase.auth.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Navegação lateral com o NavigatorRail
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) async {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
              if (index == 1) {
                print('masters clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MastersgsGrid()),
                );
              }
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentsgsGrid()),
                );
              }
              if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsGrid()),
                );
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
            destinations: const <NavigationRailDestination>[
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
