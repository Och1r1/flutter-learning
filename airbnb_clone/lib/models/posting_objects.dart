import 'package:airbnb_clone/common/common_functions.dart';
import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/review_objects.dart';
import 'package:airbnb_clone/models/user_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Posting {
  String? id;
  String? name;
  String? type;
  double? price;
  String? description;
  String? address;
  String? city;
  String? country;
  double? rating;

  Contact? host;

  List<String>? imageNames;
  List<MemoryImage>? displayImages;
  List<String>? amenities;
  List<Booking>? bookings;
  List<Review>? reviews;

  Map<String, int>? beds;
  Map<String, int>? bathrooms;

  Posting({this.id = "", this.name = "", this.type = "", this.price = 0, this.description = "", this.address = "", this.city = "", this.country = "", this.host}){
    imageNames = [];
    displayImages = [];
    amenities = [];
    bookings = [];
    reviews = [];

    beds = {};
    bathrooms = {};
    rating = 0;
    
  }

  void setImageNames(){
    imageNames = [];
    for(int i = 0; i < displayImages!.length; i++){
      imageNames!.add("pic$i.jpg");
    }
  }

  Future<void> addPostingInfoToFirestore() async{
    setImageNames();
    Map<String, dynamic> data = {
      "address": address,
      "amenities": amenities,
      "bathrooms": bathrooms,
      "description": description,
      "beds": beds,
      "city": city,
      "country": country,
      "hostID": AppConstants.currentUser.id,
      "imageNames": imageNames,
      "name": name,
      "price": price,
      "rating": 2.5,
      "type": type,
    };

    DocumentReference reference = await FirebaseFirestore.instance.collection('postings').add(data);
    id = reference.id;
    await AppConstants.currentUser.addPostingToMyPostings(this);

  }

  Future<void> addImagesToFireStore() async{
    for(int i = 0; i < displayImages!.length; i++){
      Reference reference = FirebaseStorage.instance.ref().child('postingImages/$id/${imageNames![i]}');
      await reference.putData(displayImages![i].bytes).whenComplete((){
        
      }); 
    }
  }

  Future<void> getPostingInfoFromFirestore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('postings').doc(id).get();
    this.getPostingInfoFromSnapshot(snapshot);
  }

  void getPostingInfoFromSnapshot(DocumentSnapshot snapshot){
    address = snapshot['address'];
    amenities = List<String>.from(snapshot['amenities']) ?? [];
    bathrooms = Map<String, int>.from(snapshot['bathrooms']) ?? {};
    beds = Map<String, int>.from(snapshot['beds']) ?? {};
    city = snapshot['city'] ?? "";
    country = snapshot['country'] ?? "";
    description = snapshot['description'] ?? "";

    String hostID = snapshot['hostID'] ?? "";
    host = Contact(id: hostID);

    imageNames = List<String>.from(snapshot['imageNames']) ?? [];
    name = snapshot['name'] ?? "";
    price = snapshot['price'].toDouble() ?? 0;
    rating = snapshot['rating'].toDouble() ?? 2.5;
    type = snapshot['type'] ?? "";

  }

  Future<List<MemoryImage>> getAllImagesFromStorage() async {
    displayImages = [];

    for(int i = 0; i < imageNames!.length; i++) {
      final String imagePath = "postingImages/$id/${imageNames![i]}";
      final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData();
      displayImages!.add(MemoryImage(imageData!));

    }

    return displayImages!;
  }

  String getAmenitiesString(){
    if(amenities!.isEmpty) {return "";}

    String amenitiesString = amenities.toString();
    return amenitiesString.substring(1, amenitiesString.length - 1);
  }

  updatePostingInfoToFirestore() async{
    setImageNames();
    Map<String, dynamic> data = {
      "address": address,
      "amenities": amenities,
      "bathrooms": bathrooms,
      "description": description,
      "beds": beds,
      "city": city,
      "country": country,
      "hostID": AppConstants.currentUser.id,
      "imageNames": imageNames,
      "name": name,
      "price": price,
      "rating": rating,
      "type": type,
    };
    await FirebaseFirestore.instance.doc('postings/$id').update(data);
  }

  Future<MemoryImage> getFirstImageFromStorage() async {
    if(displayImages!.isNotEmpty){return displayImages!.first;}

    final String imagePath = "postingImages/$id/${imageNames!.first}";
    final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData();
    displayImages!.add(MemoryImage(imageData!));

    return displayImages!.first;
  }

  double getCurrentRating(){
    if(reviews == null || reviews!.isEmpty) return 5.0;

    double total = 0;
    for( var r in reviews!){
      total += r.rating ?? 0;
    }

    return total / reviews!.length;
  }

  getHostFromFirestore() async {
    await host!.getContactInfoFromFirestore();
    await host!.getImageFromStorage();
  }

  int getNumGuests() {
    int? numGuests = 0;

    numGuests += beds!['small']!;
    numGuests += beds!['medium']! * 2;
    numGuests += beds!['large']! * 2;

    return numGuests;

  }

  String getBedroomText(){
    String text = "";

    if(beds!['small'] != 0){
      text += "${beds!["small"]} single/tiwn ";
    }
    if(beds!['medium'] != 0){
      text += "${beds!["medium"]} double ";
    }
    if(beds!['large'] != 0){
      text += "${beds!["large"]} double ";
    }

    return text;
  }

  String getBathroomText(){
    String text = "";

    if(bathrooms!["full"] != 0){
      text += "${bathrooms!["full"]} full ";
    }
   if(bathrooms!["half"] != 0){
      text += "${bathrooms!["half"]} half ";
    }

    return text;
  }

  String getFullAddress(){
    return "${address!}, ${city!}, ${country!}";
  }

  saveBookingData(List<DateTime> dates, context, totalAmount, hostID) async {
    Map<String, dynamic> bookingData = {
      'dates': dates,
      'name': AppConstants.currentUser.getFullName(),
      'userID': AppConstants.currentUser.id,
      'payment': totalAmount,
    };

    DocumentReference reference = await FirebaseFirestore.instance.collection('postings/$id/bookings').add(bookingData);

    Booking newBooking = Booking();
    newBooking.createBooking(this, AppConstants.currentUser.createContactFromUser(), dates);
    newBooking.id = reference.id;
    bookings!.add(newBooking);

    await AppConstants.currentUser.addBookingToFirestore(newBooking, totalAmount, hostID);

    CommonFunctions.showSnackBar(context, 'Booked Successfully');

  }

  getAllBookingsFromFirestore() async {
    bookings = [];

    QuerySnapshot snapshots = await FirebaseFirestore.instance.collection('postings/$id/bookings').get();


    for(var snapshot in snapshots.docs){
      Booking newBooking = Booking();
      await newBooking.getBookingInfoFromFirestoreFromPosting(this, snapshot);
      bookings!.add(newBooking);

    }
  }

  List<DateTime> getAllBookedDates() {
    List<DateTime> dates = [];

    bookings!.forEach((booking) {
      dates.addAll(booking.dates!);
    });

    return dates;

  }

  postNewReview(String reviewText, double ratingStars) async {
    Map<String, dynamic> data = {
      'dateTime': DateTime.now(),
      'name': AppConstants.currentUser.getFullName(),
      'rating': ratingStars,
      'text': reviewText,
      'userID': AppConstants.currentUser.id,
    };

    await FirebaseFirestore.instance.collection('postings/$id/reviews').add(data);
  }

}


class Booking {
  String id = "";
  Posting? posting;
  Contact? contact;
  List<DateTime>? dates;

  Booking();

  createBooking(Posting posting, Contact contact, List<DateTime> dates){
    this.posting = posting;
    this.contact = contact;
    this.dates = dates;
    this.dates!.sort();
  }

  getBookingInfoFromFirestoreFromPosting(Posting posting, DocumentSnapshot snapshot) async {
    this.posting = posting;
    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']);
    dates = [];

    timestamps.forEach((timestamp) {
      dates!.add(timestamp.toDate());
    });

    String contactID = snapshot['userID'] ?? "";
    String fullname = snapshot['name'] ?? "";

    _loadContactInfo(id, fullname);

    contact = Contact(id: contactID);

  }

  getBookingInfoFromFirestoreFromUser(Contact contact, DocumentSnapshot snapshot) async {
    this.contact = contact;

    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']) ?? [];

    dates = [];
    timestamps.forEach((timestamp) {
      dates!.add((timestamp.toDate()));
    });

    String postingID = snapshot['postingID'] ?? "";
    posting = Posting(id: postingID);
    await posting!.getPostingInfoFromFirestore();

    await posting!.getFirstImageFromStorage();
  }

  _loadContactInfo(String id, String fullName){

    String firstName = "";
    String lastName = "";

    firstName = fullName.split(" ")[0];
    lastName = fullName.split(" ")[1];

    contact = Contact(id: id, firstName: firstName, lastName: lastName);

  }

  String getFirstDate(){
    String firstDate = dates!.first.toIso8601String();
    return firstDate.substring(0, 10);
  }

  String getLastDate(){
    String lastDate = dates!.last.toIso8601String();
    return lastDate.substring(0, 10);
  }
}