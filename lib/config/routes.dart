import 'package:flutter/material.dart';
import 'package:smart_tracking_app/presentation/pages/auth/login_page.dart';
import 'package:smart_tracking_app/presentation/pages/home/home_page.dart';
import 'package:smart_tracking_app/presentation/pages/scanner/scanner_page.dart';
import 'package:smart_tracking_app/presentation/pages/splash/splash_page.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String scanner = '/scanner';
  
  // Routes map
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashPage(),
    login: (context) => const LoginPage(),
    home: (context) => const HomePage(),
    scanner: (context) => const ScannerPage(),
  };
} 