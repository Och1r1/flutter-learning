import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/pages/guest/account_page.dart';
import 'package:airbnb_clone/pages/guest/explore_page.dart';
import 'package:airbnb_clone/pages/guest/inbox_page.dart';
import 'package:airbnb_clone/pages/guest/saved_page.dart';
import 'package:airbnb_clone/pages/guest/trips_page.dart';
import 'package:flutter/material.dart';

class GuestHomePage extends StatefulWidget {
  static final String routeName = '/guestHomePageRoute';
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    'Explore',
    'Favourites',
    'Trips',
    'Inbox',
    'Profile',
  ];

  final List<Widget> _pages = [
    ExplorePage(),
    SavedPage(),
    TripsPage(),
    InboxPage(),
    AccountPage(),
  ];

  BottomNavigationBarItem _buildNavigationItem( int index, IconData iconData, String text) {
    return BottomNavigationBarItem(
      icon: Icon(iconData, color: AppConstants.nonselectedIcon),
      activeIcon: Icon(iconData, color: AppConstants.selectedIcon),
      label: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavigationItem(0, Icons.search, _pageTitles[0]),
          _buildNavigationItem(1, Icons.favorite_border, _pageTitles[1]),
          _buildNavigationItem(2, Icons.hotel, _pageTitles[2]),
          _buildNavigationItem(3, Icons.message, _pageTitles[3]),
          _buildNavigationItem(4, Icons.person_outline, _pageTitles[4]),
        ]
      ),
    );
  }
}
