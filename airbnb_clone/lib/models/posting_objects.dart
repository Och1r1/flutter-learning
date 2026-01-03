import 'package:airbnb_clone/constants/app_constants.dart';
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
    price = snapshot['rating'].toDouble() ?? 2.5;
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
}


class Booking {
  String id = "";
  Posting? posting;
  Contact? contact;
  List<DateTime>? dates;

  Booking();
}


class Review {
  Contact? contact;
  String? text;
  double? rating;
  DateTime? dateTime;

  Review({this.contact, this.text, this.rating, this.dateTime});
}