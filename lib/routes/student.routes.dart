import 'package:flutter/material.dart';
import '../screens/userselectionScreen.dart';
import '../screens/student/loginStudentScreen.dart';

class StudentRoutes {
  static const String home = '/dashboardStudent';
  static const String studentLogin = '/loginStudent';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => UserSelectionScreen(),
      studentLogin: (context) => LoginStudentScreen(),
      
    };
  }
}
