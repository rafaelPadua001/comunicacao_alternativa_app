import 'settings.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../../services/supabase_config.dart';

class DashboarAdmindScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obter o usuário logado
    final user = SupabaseConfig.supabase.auth.currentUser;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Admin Dashboard'),
      //   // actions: <Widget>[
      //   //   IconButton(
      //   //     icon: const Icon(Icons.add_alert),
      //   //     tooltip: 'Show Snackbar',
      //   //     onPressed: () {
      //   //       ScaffoldMessenger.of(context).showSnackBar(
      //   //         const SnackBar(content: Text('This is a snackbar')),
      //   //       );
      //   //     },
      //   //   ),
      //   //   IconButton(
      //   //     icon: const Icon(Icons.navigate_next),
      //   //     tooltip: 'Go to the next page',
      //   //     onPressed: () {
      //   //       Navigator.push(
      //   //         context,
      //   //         MaterialPageRoute<void>(
      //   //           builder: (BuildContext context) {
      //   //             return Scaffold(
      //   //               appBar: AppBar(title: const Text('Next page')),
      //   //               body: const Center(
      //   //                 child: Text(
      //   //                   'This is the next page',
      //   //                   style: TextStyle(fontSize: 24),
      //   //                 ),
      //   //               ),
      //   //             );
      //   //           },
      //   //         ),
      //   //       );
      //   //     },
      //   //   ),
      //   // ],
      // ),
      body: Row(
        children: [
          // Navegação lateral com o NavigatorRail
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
              if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsGrid()),
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
                label: Text('guardians'),
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
                label: Text('Settings'),
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
