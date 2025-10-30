import 'package:flutter/material.dart';
import 'package:flutter_application_kiemhiep/repersentation/screens/bookshelf.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/home_screen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 200)),
              TextButton (
                onPressed: (){
                   Navigator.push(context, MaterialPageRoute (
                    builder: (context) => Bookshelf(),
                    ),
                  );
                },
                child: Text(
                  'ĐỌC TRUYỆN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: (){
                },
                child: Text(
                  'THÊM ỨNG DỤNG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ), 
              ),
               TextButton(
                onPressed: (){
                },
                child: Text(
                  'GỬI MAIL GÓP Ý',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ), 
              ),
              TextButton(
                onPressed: (){
                },
                child: Text(
                  'THOÁT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ), 
              ),
            ],
          ),
        ),
      );
    }
  }