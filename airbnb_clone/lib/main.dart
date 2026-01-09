import 'package:airbnb_clone/pages/guest/profile_info_page.dart';
import 'package:airbnb_clone/pages/host/host_home_page.dart';
import 'package:airbnb_clone/pages/auth/login_page.dart';
import 'package:airbnb_clone/pages/auth/signup_page.dart';
import 'package:airbnb_clone/pages/guest/guest_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();

  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirBnB Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Couture',
        brightness: Brightness.dark,

      ).copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Couture',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
      home: LoginPage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        SignupPage.routeName: (context) => SignupPage(),
        GuestHomePage.routeName: (context) => GuestHomePage(),
        HostHomePage.routeName: (context) => HostHomePage(),
        ProfileInfoPage.routeName: (context) => ProfileInfoPage(),

      },
    );
  }
}