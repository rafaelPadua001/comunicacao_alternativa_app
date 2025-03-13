import 'package:flutter/material.dart';
import '../../services/supabase_config.dart';
// import 'studentGrid.dart';
import '../../main.dart';
import '../../widgets/profile_user.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'settingsGrid.dart';

class DashboarMasterScreen extends StatefulWidget {
  @override
  _DashboarMasterScreenState createState() => _DashboarMasterScreenState();
}

class _DashboarMasterScreenState extends State<DashboarMasterScreen> {
  String? userName;
  String? avatarImage;
  String? userType;
  Map<String, dynamic>? profileUser;

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
  
    if (user != null) {
      try {
        final getProfileUser = await SupabaseConfig.supabase
            .from('user_profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (getProfileUser != null) {
          setState(() {
            userName = getProfileUser['displayname'];
            avatarImage = getProfileUser['photourl'] != null ? getProfileUser['photourl'] : null;
            userType = getProfileUser['usertype'];
     
          });
          
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
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
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
            },
            labelType: NavigationRailLabelType.all,
            destinations:  <NavigationRailDestination>[
              NavigationRailDestination(
                icon: CircleAvatar(
                  backgroundImage: avatarImage != null ? NetworkImage(avatarImage!) : null,
                  child: avatarImage == null ? Icon(Icons.person) : null,
                  radius: 28,
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
                icon: Icon(Icons.settings),
                label: Text('Settings'),
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