import 'package:flutter/material.dart';
import '../screens/master/loginMasterScreen.dart';
import '../screens/master/dashboard.dart';

class StudentRoutes {
  static const String home = '/dashboardMaster';
  static const String masterLogin = '/loginMaster';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => DashboarMasterScreen(),
      masterLogin: (context) => LoginMasterScreen(),
      
    };
  }
}
