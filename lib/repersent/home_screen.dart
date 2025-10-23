import 'package:flutter/material.dart';
import 'package:flutter_application_x/repersent/api_test_screen.dart';
import 'package:flutter_application_x/repersent/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: Column(
          children: [
             ElevatedButton(
              onPressed: () {
                Navigator.push (
                  context, MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: Text('Search Screen')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push (
                  context, MaterialPageRoute(builder: (context) => ApiTestScreen()));
              },
              child: Text('Api Test')
            ),
          ],
        )
      );
  }
}