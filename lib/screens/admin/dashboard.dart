import 'package:comunicacao_alternativa_app/screens/addPictogramScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboarAdmindScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obter o usuário logado
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add_alert),
        //     tooltip: 'Show Snackbar',
        //     onPressed: () {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('This is a snackbar')),
        //       );
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.navigate_next),
        //     tooltip: 'Go to the next page',
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute<void>(
        //           builder: (BuildContext context) {
        //             return Scaffold(
        //               appBar: AppBar(title: const Text('Next page')),
        //               body: const Center(
        //                 child: Text(
        //                   'This is the next page',
        //                   style: TextStyle(fontSize: 24),
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),

      body: Row(
        children: [
          // Navegação lateral com o NavigatorRail
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              if(index == 4){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPictogramScreen(),
                  ),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  user == null
                      ? Text(
                        'Nenhum usuário logado',
                      ) // Caso nenhum usuário esteja logado
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
