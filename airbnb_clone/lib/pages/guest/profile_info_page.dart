import 'dart:io';

import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/pages/guest/guest_home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileInfoPage extends StatefulWidget {
  static final String routeName = '/personalInfoPageRoute';

  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  File? _newImageFile;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firstNameController = TextEditingController(
      text: AppConstants.currentUser.firstName,
    );
    _emailController = TextEditingController(
      text: AppConstants.currentUser.email,
    );
    _lastNameController = TextEditingController(
      text: AppConstants.currentUser.lastName,
    );
    _cityController = TextEditingController(
      text: AppConstants.currentUser.city,
    );
    _countryController = TextEditingController(
      text: AppConstants.currentUser.country,
    );
    _bioController = TextEditingController(text: AppConstants.currentUser.bio);
  }

  _updateInfo() {
    if(!_formKey.currentState!.validate()) { return;}

    AppConstants.currentUser.firstName = _firstNameController.text;
    AppConstants.currentUser.lastName = _lastNameController.text;
    AppConstants.currentUser.city = _cityController.text;
    AppConstants.currentUser.country = _countryController.text;
    AppConstants.currentUser.bio = _bioController.text;

    AppConstants.currentUser.updateUserInFirestore().whenComplete((){
      if(_newImageFile != null){
        AppConstants.currentUser.addImageToFirestore(_newImageFile!).whenComplete((){
          Navigator.pushNamed(context, GuestHomePage.routeName);
        });
      } else{
          Navigator.pushNamed(context, GuestHomePage.routeName);
      }
    });
  }

  _chooseImage() async {
    var imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      // Conver x file to file
      _newImageFile = File(imageFile.path);
      setState(() {
        
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        actions: [
          IconButton(
            onPressed: _updateInfo,
            icon: Icon(Icons.save_as_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(25, 25, 25, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFormField('first name', _firstNameController),
                      textFormField('last name', _lastNameController),
                      Padding(
                        padding: const EdgeInsetsGeometry.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'email'),
                          style: const TextStyle(fontSize: 25),
                          enabled: false,
                          controller: _emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsGeometry.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'password'),
                          style: const TextStyle(fontSize: 25),
                          enabled: false,
                        ),
                      ),
                      textFormField('city', _cityController),
                      textFormField('country', _countryController),
                      Padding(
                        padding: const EdgeInsetsGeometry.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'bio'),
                          style: const TextStyle(fontSize: 25),
                          maxLines: 3,
                          controller: _bioController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Please enter a bio";
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.only(top: 40, bottom: 40),
                  child: MaterialButton(
                    onPressed: _chooseImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: MediaQuery.of(context).size.width / 4.8,
                      child: CircleAvatar(
                        backgroundImage: (_newImageFile != null)
                            ? FileImage(_newImageFile!) as ImageProvider
                            : AppConstants.currentUser.displayImage,
                        radius: MediaQuery.of(context).size.width/5,

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding textFormField(String labeltext, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 20.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: labeltext),
        style: const TextStyle(fontSize: 25),
        controller: controller,
        validator: (text) {
          if (text!.isEmpty) {
            return "Please enter a $labeltext";
          }
          return null;
        },
        textCapitalization: TextCapitalization.words,
      ),
    );
  }
}
