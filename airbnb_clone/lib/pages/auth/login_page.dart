import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
                        icon: Icons.password,
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
                    onPressed: _isLoading ? null : null,
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
                    onPressed: _isLoading ? null : null,
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
