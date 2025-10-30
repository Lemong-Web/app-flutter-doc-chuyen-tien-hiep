import 'package:flutter/material.dart';

class DashLineWidget extends StatelessWidget {
  const DashLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: 1,
        width: 410,
        color: Colors.black,
      )
    );
  }
}