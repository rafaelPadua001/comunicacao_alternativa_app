import 'studentGrid.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import '../../services/supabase_config.dart';

class DashboarStudentScreen extends StatefulWidget {
  @override
  _DashboarStudentScreenState createState() => _DashboarStudentScreenState();
}

class _DashboarStudentScreenState extends State<DashboarStudentScreen> {
  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  void checkEmailVerification() async {
    final user = SupabaseConfig.supabase.auth.currentUser;

    if (user != null) {
      try {
        final response =
            await SupabaseConfig.supabase
                .from('user_profiles')
                .select('email')
                .eq('id', user.id)
                .maybeSingle();

       

        if (response == null || response['email'] == null) {
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

        final responseProfile = await SupabaseConfig.supabase
            .from('user_profiles')
            .upsert({
              'id': user.id,
              'email': user.email,
              'displayname': null, // Defina como null inicialmente
              'photourl': null,
              'usertype': 'student',
        });

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
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentgsGrid()),
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
                icon: Icon(Icons.manage_accounts),
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
