import 'dart:io';

import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Contact {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  MemoryImage? displayImage;

  Contact({this.id = "", this.firstName = "", this.lastName = "", this.displayImage});

  String getFullName(){
    return fullName = "${firstName!} ${lastName!}";
  }

  getContactInfoFromFirestore() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
  
    firstName = snapshot['firstName'] ?? "";
    lastName = snapshot['lastName'] ?? "";
  }

  Future<MemoryImage> getImageFromStorage() async {
    if(displayImage != null) {return displayImage!;}

    final String imagePath = 'userImages/$id/profile_pic.jpg';
    final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData();
    displayImage = MemoryImage(imageData!);

    return displayImage!;
  }

}

class UserModel extends Contact{
  DocumentSnapshot? snapshot;
  String? email;
  String? bio;
  String? city;
  String? country;
  bool? isHost;
  bool? isCurrentlyHosting;
  String? password;

  List<Posting>? myPostings;

  UserModel({
    String id = "",
    String firstName = "",
    String lastName = "",
    MemoryImage? displayImage,
    this.email = "",
    this.bio = "",
    this.city = "",
    this.country = "",
  }) : super(id: id, firstName: firstName, lastName: lastName, displayImage: displayImage) {
    isHost = false;
    isCurrentlyHosting = false;
    myPostings = [];
  }

  Future<void> addUserToFirestore() async{
    Map<String, dynamic> data = {
      "bio": bio,
      "city": city,
      "country": country,
      "email": email,
      "firstName": firstName,
      "isHost": isHost,
      "lastName": lastName,
      "myPostingIDs": [],
      "savedPostingIDs": [],
      "earnings": 0
    };

    await FirebaseFirestore.instance.doc('users/$id').set(data);
  }

  Future<void> addImageToFireStore(File imageFile) async{
    Reference reference = FirebaseStorage.instance.ref().child('userImages/$id/profile_pic.jpg');
    await reference.putFile(imageFile).whenComplete(() {});
    displayImage = MemoryImage(imageFile.readAsBytesSync());

  }

  Future<void> getPersonalInfoFromFireStore() async{
    await getUserInfoFromFirestore();
    await getImageFromStorage();
    await getMyPostingsFromFirestore();
  }

  Future<void> getUserInfoFromFirestore() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    this.snapshot = snapshot;
    firstName = snapshot['firstName'] ?? "";
    lastName = snapshot['lastName'] ?? "";
    email = snapshot['email'] ?? "";
    bio = snapshot['bio'] ?? "";
    city = snapshot['email'] ?? "";
    country = snapshot['country'] ?? "";
    isHost = snapshot['isHost'] ?? "";

  }

  Future<MemoryImage> getImageFromStorage() async{
    if(displayImage != null) {return displayImage!;}
    final String imagePath = "userImages/$id/profile_pic.jpg";
    final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData();
    displayImage = MemoryImage(imageData!);

    return displayImage!;
  }

  Future<void> getMyPostingsFromFirestore() async{
    List<String> myPostingIDs = List<String>.from(snapshot!['myPostingIDs']) ?? [];

    for(String postingID in myPostingIDs){
      Posting eachPosting = Posting(id: postingID);
      await eachPosting.getPostingInfoFromFirestore();

      await eachPosting.getAllImagesFromStorage();

      myPostings!.add(eachPosting);
    }
  }




  Future<void> becomHost() async{
    isHost = true;
    Map<String, dynamic> data = {
      'isHost': true,
    };

    await FirebaseFirestore.instance.doc('users/$id').update(data);
    changeCurrentlyHosting(true);
  }

  void changeCurrentlyHosting(bool isHosting){
    isCurrentlyHosting = isHosting;
  }

  Contact createContactFromUser(){
    return Contact(
      id: id,
      firstName: firstName,
      lastName: lastName,
      displayImage: displayImage
    );
  }

  Future<void> addPostingToMyPostings(Posting posting) async{
    myPostings!.add(posting);

    List<String> myPostingIDs = [];
    myPostings!.forEach((posting) {
      myPostingIDs.add(posting.id!);
    });

    await FirebaseFirestore.instance.doc('users/$id').update({
      'myPostingIDs': myPostingIDs
    });
  }
  
}