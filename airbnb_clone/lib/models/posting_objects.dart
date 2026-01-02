import 'package:airbnb_clone/models/user_objects.dart';
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

  Map<String, int>? beds;
  Map<String, int>? bathrooms;

  Posting({this.id = "", this.name = "", this.type = "", this.price = 0, this.description = "", this.address = "", this.city = "", this.country = "", this.host}){
    imageNames = [];
    displayImages = [];
    amenities = [];

    beds = {};
    bathrooms = {};
    rating = 0;
    
  }

}