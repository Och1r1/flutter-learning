import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(BallPage());
}

class BallPage extends StatelessWidget {
  const BallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Ask Me Anything"),
          titleTextStyle: TextStyle(color: Colors.white),
          centerTitle: false,
          backgroundColor: Colors.blue[900],
        ),
        body: Ball(),
      ),
    );
  }
}

class Ball extends StatefulWidget {
  const Ball({super.key});

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {

  int ballNumber = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        ballNumber = Random().nextInt(5) + 1;
      }),
      child: Container(
        color: Colors.blue[800],
        child: Center(
          child: Image.asset('images/ball$ballNumber.png'),
          ),
      ),
    );
  }
}