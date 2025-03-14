import 'routes/student.routes.dart' as studentRoutes;
import 'routes/admin.routes.dart' as adminRoutes;
import 'package:comunicacao_alternativa_app/screens/userselectionScreen.dart';
import 'screens/student/loginStudentScreen.dart' as studentScreen;
import 'screens/admin/loginAdminScreen.dart' as adminScreen;
import 'screens/master/loginMasterScreen.dart' as masterScreen;
import 'screens/userselectionScreen.dart' as userselectionScreen;
import 'screens/admin/dashboard.dart' as dashboardScreen;
import 'screens/student/dashboard.dart' as dashboardStudentScreen;
import 'screens/master/dashboard.dart' as dashboardMasterScreen;
import 'models/pictogram.dart' as modelPictogram;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'widgets/pictogram_card.dart' as widget;
import 'models/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_config.dart'; // Importando a configuração

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if(!Hive.isAdapterRegistered(0)){
    Hive.registerAdapter(modelPictogram.PictogramAdapter());
  }
  if(!Hive.isAdapterRegistered(1)){
    Hive.registerAdapter(StudentAdapter());
  }
  
  // Exclua a caixa existente (se necessário)
  //await Hive.deleteBoxFromDisk('pictograms');

  // Abra a caixa
  await Hive.openBox<modelPictogram.Pictogram>('pictograms');
  await Hive.openBox<Student>('student');

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

   await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pictogram App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        
        body: Center(
          child: widget.PictogramCard(),
        ),
      ),
       initialRoute: '/',
       onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/loginStudent':
            return MaterialPageRoute(builder: (context) => studentScreen.LoginStudentScreen());
          case '/loginAdmin':
            return MaterialPageRoute(builder: (context) => adminScreen.LoginAdminScreen());
          case '/loginMaster':
            return MaterialPageRoute(builder: (context) => masterScreen.LoginMasterScreen());
          case '/dashboardAdmin':
            return MaterialPageRoute(builder: (context) => dashboardScreen.DashboarAdmindScreen());  // Definindo a rota
          case '/dashboardStudent':
            return MaterialPageRoute(builder: (context) => dashboardStudentScreen.DashboarStudentScreen());
          case '/dashboardMaster':
            return MaterialPageRoute(builder: (context) => dashboardMasterScreen.DashboarMasterScreen());
          default:
            return MaterialPageRoute(builder: (context) => userselectionScreen.UserSelectionScreen());
        }
      },
      // routes: {
       
      
      //   '/dasboardAdmin': (context) => dasboardScreen.DashboarAdmindScreen(),
      //   ...adminRoutes.AdminRoutes.getRoutes(),
      // },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Erro')),
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
      },
    );
  }
}

