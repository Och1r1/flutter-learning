import 'package:flutter/material.dart';
import 'price_screen.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.lightBlue,
        appBarTheme: AppBarThemeData(backgroundColor: Colors.lightBlue),
        scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}