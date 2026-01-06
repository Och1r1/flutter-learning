import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CommonFunctions {

  static void showSnackBar(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),));
  }


  static Future<dynamic> sendRequestToAPI(String apiUrl) async {
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));

    try {
      if (responseFromAPI.statusCode == 200) {
        String dataFromApi = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromApi);
        return dataDecoded;
      } else {
        return "error";
      }
    } catch (errorMsg) {
      return "error";
    }
  }

  static Future<LatLng?> propertyLatLong(String address) async {
    try{
      List<Location> locations = await locationFromAddress(address);
      if(locations.isNotEmpty){
        final loc = locations.first;
        return LatLng(loc.latitude, loc.longitude);
      }
    } catch(e){
      print("error: $e");
    }
    return null;
  }
}