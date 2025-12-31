import 'package:airbnb_clone/common/common_functions.dart';
import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/user_objects.dart';
import 'package:airbnb_clone/pages/auth/signup_page.dart';
import 'package:airbnb_clone/pages/guest/guest_home_page.dart';
import 'package:airbnb_clone/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/loginPageRoute';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  void _signUp(){
    Navigator.pushNamed(context, SignupPage.routeName);
  }

  void _login() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          
        if(firebaseUser.user != null){
          final userID = firebaseUser.user!.uid;
          AppConstants.currentUser= UserModel(id: userID);

          await AppConstants.currentUser.getPersonalInfoFromFireStore();

          CommonFunctions.showSnackBar(context, "you logged in successfully");

          _formKey.currentState!.reset();
          Navigator.pushReplacementNamed(context, GuestHomePage.routeName);
          
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case "email-already-in-use":
            errorMessage = "This email is already registered.";
            break;
          case "invalid-email":
            errorMessage = "Please enter a valid email address.";
            break;
          case "weak-password":
            errorMessage =
                "Password is too weak. Please use a stronger one. Use at-least 6 characters.";
            break;
          default:
            errorMessage = "Sign up failed. Please try again later.";
        }
        CommonFunctions.showSnackBar(context, errorMessage);
      } catch (e) {
        CommonFunctions.showSnackBar(context, e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.width * 0.8,
                ),

                SizedBox(height: 20),

                Text(
                  "Find Stays & Rentals with \n${AppConstants.appName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                ),

                SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 15,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 22.0)),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 15,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),

                const SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
