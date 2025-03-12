import 'package:flutter/material.dart';
import '../screens/master/loginMasterScreen.dart';
import '../screens/student/dashboard.dart';

class StudentRoutes {
  static const String home = '/dashboardStudent';
  static const String masterLogin = '/loginMaster';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // home: (context) => DashboarStudentScreen(),
      masterLogin: (context) => LoginMasterScreen(),
      
    };
  }
}
