
import 'package:flutter/material.dart';
import '../../services/supabase_config.dart';
import 'studentGrid.dart';
import '../../main.dart';
import '../../widgets/profile_user.dart';

class DashboarStudentScreen extends StatefulWidget {
  @override
  _DashboarStudentScreenState createState() => _DashboarStudentScreenState();
}

class _DashboarStudentScreenState extends State<DashboarStudentScreen> {
  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      checkEmailVerification();
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

  @override
  Widget build(BuildContext context) {
    final user = SupabaseConfig.supabase.auth.currentUser;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
              if (index == 1) {
                print('Account clicked');
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ProfileUser()),
                );
              }
              if (index == 4) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingsGrid()),
                // );
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const <NavigationRailDestination>[
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
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  user == null
                      ? Text('Nenhum usuário logado')
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text('Bem-vindo, ${user.email}'),
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
