import 'package:flutter/material.dart';
import 'package:flutter_application_x/repersent/api_test_screen.dart';
import 'package:flutter_application_x/repersent/home_screen.dart';
import 'package:flutter_application_x/repersent/search_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
