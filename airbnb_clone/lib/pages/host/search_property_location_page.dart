import 'package:airbnb_clone/common/common_functions.dart';
import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/predicted_places.dart';
import 'package:airbnb_clone/widgets/places_name_ui.dart';
import 'package:flutter/material.dart';

class SearchPropertyLocationPage extends StatefulWidget {
  const SearchPropertyLocationPage({super.key});

  @override
  State<SearchPropertyLocationPage> createState() =>
      _SearchPropertyLocationPageState();
}

class _SearchPropertyLocationPageState
    extends State<SearchPropertyLocationPage> {
  TextEditingController placeAddressTextEditingController =
      TextEditingController();
  List<PredictedPlaces> placesList = [];

  

  Future<void> searchLocation(String locationName) async {
    if (locationName.length > 1) {
      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=${AppConstants.googleMapsKey}";

      var responseFromPlacesAPI = await CommonFunctions.sendRequestToAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        return;
      }

      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionResultInJson = responseFromPlacesAPI["predictions"];

        var predictionsList = (predictionResultInJson as List)
            .map(
              (eachPlacePrediction) =>
                  PredictedPlaces.fromJson(eachPlacePrediction),
            )
            .toList();

        setState(() {
          placesList = predictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.black,
              elevation: 5,
              child: Container(
                height: 164,
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 48,
                  right: 24,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 6),

                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const Center(
                          child: Text(
                            "Please write address",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Image.asset(
                          "assets/images/final.png",
                          height: 16,
                          width: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: TextField(
                                controller: placeAddressTextEditingController,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                onChanged: (inputText) {
                                  searchLocation(inputText);
                                },
                                decoration: const InputDecoration(
                                  hintText: 'type here...',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    left: 11,
                                    top: 9,
                                    bottom: 9,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // display prediction results for property places
            (placesList.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsetsGeometry.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index){
                        return Card(
                          color: Colors.grey[850],
                          elevation: 3,
                          //ui
                          child: PlacesNameUi(
                            predictedPlacesData: placesList[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 2,),
                      itemCount: placesList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
