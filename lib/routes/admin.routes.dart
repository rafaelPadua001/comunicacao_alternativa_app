import 'package:flutter/material.dart';
import '../screens/admin/loginAdminScreen.dart';
import '../screens/admin/dashboard.dart';


class AdminRoutes {
  static const String home = '/dasboardAdmin';
  static const String adminLogin = '/loginAdmin';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => DashboarAdmindScreen(),
      adminLogin: (context) => LoginAdminScreen(),
      
    };
  }
}
