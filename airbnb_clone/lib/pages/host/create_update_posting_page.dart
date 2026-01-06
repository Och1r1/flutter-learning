import 'dart:io';

import 'package:airbnb_clone/common/common_functions.dart';
import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/global.dart';
import 'package:airbnb_clone/pages/host/host_home_page.dart';
import 'package:airbnb_clone/pages/host/search_property_location_page.dart';
import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/widgets/facilities_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CreateUpdatePostingPage extends StatefulWidget {
  final Posting? posting;

  const CreateUpdatePostingPage({super.key, this.posting});

  @override
  State<CreateUpdatePostingPage> createState() =>
      _CreateUpdatePostingPageState();
}

class _CreateUpdatePostingPageState extends State<CreateUpdatePostingPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _amenitiesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> _propertyTypes = [
    'detatched house',
    'villa',
    'apartment',
    'condo',
    'flat',
    'town house',
    'studio',
    'room',
  ];

  String? _propertyTypeChosen;

  Map<String, int>? _beds;
  Map<String, int>? _bathrooms;
  List<MemoryImage>? _images;
  bool _isLoading = false;

  void _setUpInitialValuesForTextFields() {
    if (widget.posting == null) {
      _beds = {'small': 0, 'medium': 0, 'large': 0};
      _bathrooms = {'full': 0, 'half': 0};

      _images = [];
      _nameController = TextEditingController(text: "");
      _priceController = TextEditingController(text: "");
      _descriptionController = TextEditingController(text: "");
      _addressController = TextEditingController(text: "");
      _cityController = TextEditingController(text: "");
      _countryController = TextEditingController(text: "");
      _amenitiesController = TextEditingController(text: "");
    } else{
      _nameController = TextEditingController(text: widget.posting!.name);
      _priceController = TextEditingController(text: widget.posting!.price.toString());
      _descriptionController = TextEditingController(text: widget.posting!.description);
      _addressController = TextEditingController(text: widget.posting!.address);
      _cityController = TextEditingController(text: widget.posting!.city);
      _countryController = TextEditingController(text: widget.posting!.country);
      _amenitiesController = TextEditingController(text: widget.posting!.getAmenitiesString());
      _beds = widget.posting!.beds;
      _bathrooms = widget.posting!.bathrooms;
      _images = widget.posting!.displayImages;
      _propertyTypeChosen = widget.posting!.type;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setUpInitialValuesForTextFields();
  }

  _selectImage(int index) async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      // Conver x file to file
      File originalFile = File(pickedImage.path);

      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalFile.path,
        quality: 15,
      );

      if (compressedBytes != null) {
        final compressedFile = File(targetPath)
          ..writeAsBytesSync(compressedBytes);

        MemoryImage newImage = MemoryImage(compressedFile.readAsBytesSync());

        // check duplicates
        bool isDuplicate = _images!.any((img){
          final bytes = (img as MemoryImage).bytes;
          if(bytes.length != compressedBytes.length) return false;

          for(int i = 0; i < bytes.length; i++){
            if(bytes[i] != compressedBytes[i]) return false;
          }

          return true;
        });

        if(isDuplicate){
          CommonFunctions.showSnackBar(context, "You have already uploaded this photo");
          return;
        }

        if (index < 0){
          _images!.add(newImage);
        }
        else{
          _images![index] = newImage;
        }

        setState(() {
          
        });
      }
    }
  }

  Future<void> _storePosting() async {
    if (!_formKey.currentState!.validate()) return;

    if (_propertyTypeChosen == null) {
      CommonFunctions.showSnackBar(context, "Please select property type");
      return;
    }

    if (_images == null || _images!.isEmpty) {
      CommonFunctions.showSnackBar(context, "Please upload at least one image");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Posting posting = Posting();
      posting.name = _nameController.text.toLowerCase();
      posting.price = double.parse(_priceController.text.trim());
      posting.description = _descriptionController.text.toLowerCase();
      posting.address = _addressController.text.toLowerCase();
      posting.city = _cityController.text.toLowerCase();
      posting.country = _countryController.text.toLowerCase();
      posting.amenities =
          _amenitiesController.text.toLowerCase().split(",");
      posting.type = _propertyTypeChosen!.toLowerCase();
      posting.beds = _beds;
      posting.bathrooms = _bathrooms;
      posting.displayImages = _images;
      posting.host = AppConstants.currentUser.createContactFromUser();
      posting.setImageNames();

      if (widget.posting == null) {
        posting.rating = 2.5;
        posting.bookings = [];
        posting.reviews = [];

        await posting.addPostingInfoToFirestore();
        await posting.addImagesToFireStore();

        CommonFunctions.showSnackBar(context, 'Your new property listing uploaded successfully');
      }
      else{
        posting.rating = widget.posting!.rating;
        posting.bookings = widget.posting!.bookings;
        posting.reviews = widget.posting!.reviews;
        posting.id = widget.posting!.id;

        for (int i = 0; i < AppConstants.currentUser.myPostings!.length; i++){
          if (AppConstants.currentUser.myPostings![i].id == posting.id){
            AppConstants.currentUser.myPostings![i] = posting;
            break;
          }
        }

        posting.updatePostingInfoToFirestore().whenComplete((){
          setState(() => _isLoading = false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HostHomePage(index: 1)));
        });

        CommonFunctions.showSnackBar(context, 'Your post updated successfully');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HostHomePage(index: 1),
        ),
      );
    } catch (e) {
      CommonFunctions.showSnackBar(
        context,
        "Failed to upload posting. Please try again.",
      );
      debugPrint("Upload error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.posting == null ? 'Add New Posting' : 'Update Posting',
        ),
        actions: <Widget>[
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    _storePosting();
                  },
                  icon: const Icon(
                    Icons.upload_file_outlined,
                    color: Colors.white,
                  ),
                ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(25, 25, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Post to Online Marketplace',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData.dark().copyWith(
                      inputDecorationTheme: const InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // posting name
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Posting Name',
                          ),
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                          controller: _nameController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Please enter a valid name";
                            }
                            return null;
                          },
                        ),

                        // dropdown
                        Padding(
                          padding: const EdgeInsetsGeometry.only(top: 30),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Property Type',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.grey[900],
                                items: _propertyTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  _propertyTypeChosen = value;
                                  setState(() {});
                                },
                                isExpanded: true,
                                value: _propertyTypeChosen,
                                hint: const Text(
                                  'Select property type',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // price
                        Padding(
                          padding: const EdgeInsetsGeometry.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                  ),
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return "please enter a valid price";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  "💲 / night",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // description
                        Padding(
                          padding: const EdgeInsetsGeometry.only(top: 20),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Description",
                            ),
                            style: const TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                            controller: _descriptionController,
                            maxLines: 3,
                            minLines: 1,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Please enter a valid description";
                              }
                              return null;
                            },
                          ),
                        ),

                        // address
                        Padding(
                          padding: const EdgeInsetsGeometry.only(top: 20),
                          child: GestureDetector(
                            onTap: () async {
                              String res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => SearchPropertyLocationPage(),
                                ),
                              );

                              if (res == "placeSelected") {
                                setState(() {
                                  _addressController.text = addressOfProperty;
                                  _cityController.text = cityOfProperty;
                                  _countryController.text = countryOfProperty;
                                });
                              }
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: _addressController,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white70,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Address",
                                labelStyle: TextStyle(color: Colors.white70),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Please enter a valid description";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        // beds
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'Beds',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FacilitiesWidget(
                          type: 'Twin/Single',
                          startValue: _beds!['small']!,
                          decreaseValue: () {
                            _beds!['small'] = (_beds!['small']! - 1).clamp(
                              0,
                              50,
                            );
                          },
                          increaseValue: () {
                            _beds!['small'] = (_beds!['small']! + 1).clamp(
                              0,
                              50,
                            );
                          },
                        ),

                        FacilitiesWidget(
                          type: 'Double',
                          startValue: _beds!['medium']!,
                          decreaseValue: () {
                            _beds!['medium'] = (_beds!['medium']! - 1).clamp(
                              0,
                              50,
                            );
                          },
                          increaseValue: () {
                            _beds!['medium'] = (_beds!['medium']! + 1).clamp(
                              0,
                              50,
                            );
                          },
                        ),

                        FacilitiesWidget(
                          type: 'King/Queen',
                          startValue: _beds!['large']!,
                          decreaseValue: () {
                            _beds!['large'] = (_beds!['large']! - 1).clamp(
                              0,
                              50,
                            );
                          },
                          increaseValue: () {
                            _beds!['large'] = (_beds!['large']! + 1).clamp(
                              0,
                              50,
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        // bathrooms
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'Bathrooms',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        FacilitiesWidget(
                          type: 'Full',
                          startValue: _bathrooms!['full']!,
                          decreaseValue: () {
                            _bathrooms!['full'] = (_bathrooms!['full']! - 1)
                                .clamp(0, 50);
                          },
                          increaseValue: () {
                            _bathrooms!['full'] = (_bathrooms!['full']! + 1)
                                .clamp(0, 50);
                          },
                        ),
                        FacilitiesWidget(
                          type: 'Half',
                          startValue: _bathrooms!['half']!,
                          decreaseValue: () {
                            _bathrooms!['half'] = (_bathrooms!['half']! - 1)
                                .clamp(0, 50);
                          },
                          increaseValue: () {
                            _bathrooms!['half'] = (_bathrooms!['half']! + 1)
                                .clamp(0, 50);
                          },
                        ),

                        // amenities
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Amenities (comma seperated)',
                            ),
                            style: TextStyle(fontSize: 22, color: Colors.white),

                            controller: _amenitiesController,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'Please enter valid aminities';
                              } else {
                                return null;
                              }
                            },
                            maxLines: 3,
                            minLines: 1,
                          ),
                        ),

                        // photo
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Photos',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _images!.length + 1,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 25,
                                crossAxisSpacing: 25,
                                childAspectRatio: 3 / 2,
                              ),
                          itemBuilder: (context, index) {
                            if (index == _images!.length) {
                              return Container(
                                color: Colors.grey,
                                child: IconButton(
                                  onPressed: () {
                                    _selectImage(-1);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                            return MaterialButton(
                              onPressed: () {},
                              child: Image(
                                image: _images![index],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ],
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
}
