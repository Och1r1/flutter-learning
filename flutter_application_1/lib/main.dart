import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My mom is kinda a homeless',
          style: TextStyle(
            color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
        backgroundColor: Colors.blueGrey[100],
        
        body: Center(child: Image.asset('images/speed.jpeg'))
      )
    ),
  );
}

