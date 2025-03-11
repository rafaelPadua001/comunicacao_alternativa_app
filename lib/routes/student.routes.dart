import 'package:flutter/material.dart';
// import '../screens/userselectionScreen.dart';
import '../screens/student/loginStudentScreen.dart';
import '../screens/student/dashboard.dart';

class StudentRoutes {
  static const String home = '/dashboardStudent';
  static const String studentLogin = '/loginStudent';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => DashboarStudentScreen(),
      studentLogin: (context) => LoginStudentScreen(),
      
    };
  }
}
