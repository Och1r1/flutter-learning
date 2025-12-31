import 'package:flutter/material.dart';

class GuestHomePage extends StatefulWidget {
  static final String routeName = '/guestHomePageRoute';
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  final List<String> _pageTitles = [
    'Explore',
    'Favourites',
    'Trips',
    'Inbox',
    'Profile',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home"
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }
}