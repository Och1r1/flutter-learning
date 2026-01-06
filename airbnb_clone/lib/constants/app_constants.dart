import 'package:airbnb_clone/models/user_objects.dart';
import 'package:flutter/material.dart';

class AppConstants {

  static final String appName = 'AirBnB Clone';
  static final String googleMapsKey = 'AIzaSyAvSGb8hPJx8li25245SCcJOWznIdP2kgQ';

  static UserModel currentUser = UserModel();

  static final Color selectedIcon = Colors.white;
  static final Color nonselectedIcon = Colors.grey;

  static final Map<int, String> monthsDictionaryMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  static final Map<int, int> daysInMonthsMap = {
    1: 31,
    2: DateTime.now().year % 4 == 0 ? 29 : 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31,
  };
  
}
