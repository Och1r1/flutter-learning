import 'dart:io';
import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'messaging_objects.dart';
import 'posting_objects.dart';

class Contact {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  MemoryImage? displayImage;

  Contact({this.id = "", this.firstName = "", this.lastName="", this.displayImage});

  String getFullName(){
    return fullName = firstName! + " " + lastName!;
  }

  Future<void> getContactInfoFromFirestore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    firstName = snapshot['firstName'] ?? "";
    lastName = snapshot['lastName'] ?? "";
  }

  Future<MemoryImage> getImageFromStorage() async {
    if(displayImage != null){return displayImage!;}

    final String imagePath = "userImages/$id/profile_pic.jpg";
    final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData();
    displayImage = MemoryImage(imageData!);

    return displayImage!;
  }

  UserModel createUserFromContact(){
    return UserModel(
      id: id!,
      firstName: firstName!,
      lastName: lastName!,
      displayImage: displayImage!
    );
  }
}



class UserModel extends Contact {
  DocumentSnapshot? snapshot;
  String? email;
  String? bio;
  String? city;
  String? country;
  bool? isHost;
  bool? isCurrentlyHosting;
  String? password;

  List<Booking>? bookings;
  List<Posting>? savedPostings;
  List<Posting>? myPostings;

  UserModel({
    String id = "",
    String firstName = "",
    String lastName = "",
    MemoryImage? displayImage,
    this.email = "",
    this.bio = "",
    this.city = "",
    this.country = ""
  }) : super(id: id, firstName: firstName, lastName: lastName, displayImage: displayImage) {
    isHost = false;
    isCurrentlyHosting = false;
    savedPostings = [];
    bookings = [];
    myPostings = [];
  }

  Future<void> addUserToFirestore() async {
    Map<String, dynamic> data = {
      "bio" : bio,
      "city" : city,
      "country": country,
      "email": email,
      "firstName": firstName,
      "isHost": false,
      "lastName": lastName,
      "myPostingIDs": [],
      "savedPostingIDs": [],
      "earnings": 0
    };
    await FirebaseFirestore.instance.doc('users/$id').set(data);
  }

  Future<void> addImageToFirestore(File imageFile) async {
    Reference reference = FirebaseStorage.instance.ref().child('userImages/$id/profile_pic.jpg');
    await reference.putFile(imageFile).whenComplete(() {});
    displayImage = MemoryImage(imageFile.readAsBytesSync());
  }

  Future<void> getPersonalInfoFromFireStore() async {
    await getUserInfoFromFirestore();
    await getImageFromStorage();
    await getSavedPostingsFromFirestore();
    await getMyPostingsFromFirestore();
    await getAllBookingsFromFirestore();
  }

  getAllBookingsFromFirestore() async {
    bookings = [];
    QuerySnapshot snapshots = await FirebaseFirestore.instance.collection('users/$id/bookings').get();

    for(var snapshot in snapshots.docs){
      Booking userBooking = Booking();
      await userBooking.getBookingInfoFromFirestoreFromUser(createContactFromUser(), snapshot);
      bookings!.add(userBooking);
    }
  }

  Future<void> getUserInfoFromFirestore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    this.snapshot = snapshot;
    firstName = snapshot['firstName'] ?? "";
    lastName = snapshot['lastName'] ?? "";
    email = snapshot['email'] ?? "";
    bio = snapshot['bio'] ?? "";
    city = snapshot['city'] ?? "";
    country = snapshot['country'] ?? "";
    isHost = snapshot['isHost'] ?? false;
  }

  Future<MemoryImage> getImageFromStorage() async {
    if(displayImage != null){return displayImage!;}
    final String imagePath = "userImages/$id/profile_pic.jpg";
    final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData();
    displayImage = MemoryImage(imageData!);

    return displayImage!;
  }

  Future<void> getMyPostingsFromFirestore() async {
    List<String> myPostingIDs = List<String>.from(snapshot!['myPostingIDs']) ?? [];
    for(String postingID in myPostingIDs) {
      Posting eachPost = Posting(id: postingID);
      await eachPost.getPostingInfoFromFirestore();
      await eachPost.getAllBookingsFromFirestore();
      await eachPost.getAllImagesFromStorage();

      myPostings!.add(eachPost);
    }
  }

  Future<void> becomeHost() async {
    isHost = true;
    Map<String,dynamic> data = {
      'isHost' : true,
    };
    await FirebaseFirestore.instance.doc('users/$id').update(data);
    changeCurrentlyHosting(true);
  }

  changeCurrentlyHosting(bool isHosting) {
    isCurrentlyHosting = isHosting;
  }

  Contact createContactFromUser() {
    return Contact(
      id: id,
      firstName: firstName,
      lastName: lastName,
      displayImage: displayImage,
    );
  }

  addPostingToMyPostings(Posting posting) async {
    myPostings!.add(posting);

    List<String> myPostingIDs = [];
    myPostings!.forEach((posting) {
      myPostingIDs.add(posting.id!);
    });

    await FirebaseFirestore.instance.doc('users/$id').update({
      'myPostingIDs': myPostingIDs,
    });
  }

  addBookingToFirestore(Booking booking, int totalPriceForAllNights, hostID) async {
    //ADD BOOKING TO CURRENT USER [GUEST] RECORD
    Map<String, dynamic> data = {
      'dates': booking.dates,
      'postingID': booking.posting!.id!,
    };
    await FirebaseFirestore.instance.doc('users/$id/bookings/${booking.id}').set(data);

    //UPDATE HOST EARNINGS
    String earningsOld = "";
    await FirebaseFirestore.instance.collection("users").doc(hostID).get().then((dataSnap)
    {
      earningsOld = dataSnap["earnings"].toString();
    });
    await FirebaseFirestore.instance.collection("users").doc(hostID).update(
    {
      "earnings": totalPriceForAllNights + int.parse(earningsOld),
    });

    bookings!.add(booking);
    await initNewBookingConversation(booking);
  }

  initNewBookingConversation(Booking booking) async {
    Conversation conversation = Conversation();
    await conversation.addConversationToFirestore(booking.posting!.host!);

    String text = "[New Booking] hello, send message here.";
    await conversation.addMessageToFirestore(text);
  }

  List<Booking> getUpcomingTrips() {
    List<Booking> upcomingTrips = [];

    bookings!.forEach((booking) {
      if(booking.dates!.last.compareTo(DateTime.now()) > 0) {
        upcomingTrips.add(booking);
      }
    });

    return upcomingTrips;
  }

  List<Booking> getPreviousTrips() {
    List<Booking> previousTrips = [];

    bookings!.forEach((booking) {
      if(booking.dates!.last.compareTo(DateTime.now()) <= 0) {
        previousTrips.add(booking);
      }
    });

    return previousTrips;
  }

  List<DateTime> getAllBookedDates() {
    List<DateTime> allBookedDates = [];

    myPostings!.forEach((posting) {
      posting.bookings!.forEach((booking) {
        allBookedDates.addAll(booking.dates!);
      });
    });

    return allBookedDates;
  }

  addSavedPosting(Posting posting) async {
    for(var savedPosting in savedPostings!){
      if(savedPosting.id == posting.id){
        return;
      }
    }
    savedPostings!.add(posting);

    List<String> savedPostingIDs = [];

    savedPostings!.forEach((savedPosting){
      savedPostingIDs.add(savedPosting.id!);
    });

    await FirebaseFirestore.instance.doc('users/$id').update({
      'savedPostingIDs': savedPostingIDs,
    });
  }

  removeSavedPosting(Posting posting) async{
    for(int i = 0; i < savedPostings!.length; i++){
      if(savedPostings![i].id == posting.id){
        savedPostings!.removeAt(i);
        break;
      }
    }

    List<String> savedPostingIDs = [];

    savedPostings!.forEach((savedPosting){
      savedPostingIDs.add(savedPosting.id!);
    });

    await FirebaseFirestore.instance.doc('users/$id').update({
      'savedPostingIDs': savedPostingIDs,
    });
  }

  getSavedPostingsFromFirestore() async {
    List<String> savedPostingIDs = List<String>.from(snapshot!['savedPostingIDs']) ?? [];
    for(String postingID in savedPostingIDs){
      Posting newPosting = Posting(id: postingID);
      
      await newPosting.getPostingInfoFromFirestore();
      await newPosting.getFirstImageFromStorage();
      savedPostings!.add(newPosting);
    }
  }

  postNewReview(String reviewText, double ratingStars) async {
    Map<String, dynamic> data = {
      'dateTime': DateTime.now(),
      'name': AppConstants.currentUser.getFullName(),
      'rating': ratingStars,
      'text': reviewText,
      'userID': AppConstants.currentUser.id,
    };

    await FirebaseFirestore.instance.collection('users/$id/reviews').add(data);
  }

  updateUserInFirestore() async{
    Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'city': city,
      'country': country,
    };

    await FirebaseFirestore.instance.doc('users/$id').update(data);
  }

}