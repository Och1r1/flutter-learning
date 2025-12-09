import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/sugar.jpeg'),
              ),
              Text('Sugar-Ochir Tseesuren',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              Text('Computing Student',
              style: TextStyle(
                fontFamily: 'Source Code Pro',
                fontSize: 20,
                color: Colors.teal[900],
                fontWeight: FontWeight.bold
              ),)
            ]
          )
        ),
      ),
    );
  }
}