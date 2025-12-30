import 'dart:io';

import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  bool _isLoading = false;

  Future<void> _chooseImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null){
      // Conver x file to file
      File originalFile = File(pickedImage.path);

      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg"
      );


      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalFile.path,
        quality: 25,
      );

      if (compressedBytes != null){
        final compressedFile = File(targetPath)..writeAsBytesSync(compressedBytes);

        setState(() {
          _imageFile = compressedFile;
        });

        print("OriginalSize: ${(originalFile.lengthSync() / 1024 ).toStringAsFixed(2)} KB");
        print("CompressedSize: ${(_imageFile!.lengthSync() / 1024 ).toStringAsFixed(2)} KB");

      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Image.asset(
              "assets/images/signup.png",
              width: MediaQuery.of(context).size.width * 0.8,
            ),

            SizedBox(height: 15),

            Text(
              "Start Your Journey with \n${AppConstants.appName}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26),
            ),

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
                  CustomTextField(
                    controller: _firstNameController,
                    label: "First Name",
                    icon: Icons.person,
                  ),
                  CustomTextField(
                    controller: _lastNameController,
                    label: "Last Name",
                    icon: Icons.person,
                  ),
                  CustomTextField(
                    controller: _cityController,
                    label: "City",
                    icon: Icons.location_city,
                  ),
                  CustomTextField(
                    controller: _countryController,
                    label: "Country",
                    icon: Icons.flag,
                  ),
                  CustomTextField(
                    controller: _bioController,
                    label: "Tell us a little about u",
                    icon: Icons.info,
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            MaterialButton(
              onPressed: _chooseImage,
              child: (_imageFile == null)
                  ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                  : CircleAvatar(
                      backgroundImage: FileImage(_imageFile!),
                      radius: 60,
                    ),
            ),

            SizedBox(height: 30),

            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : MaterialButton(
                  onPressed: () {}, 
                  color: Colors.white,
                  height: 55,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )
                ),
            
            
            
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
