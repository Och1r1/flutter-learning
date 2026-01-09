import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/review_objects.dart';
import 'package:airbnb_clone/models/user_objects.dart';
import 'package:airbnb_clone/pages/guest/review_form_ui.dart';
import 'package:airbnb_clone/widgets/review_design_tile_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  static final String routeName = '/viewProfilePageRoute';
  final Contact? contact;

  const ViewProfilePage({super.key, this.contact, });

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  Contact? _contact;
  UserModel? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.contact!.id == AppConstants.currentUser.id){
      _user = AppConstants.currentUser;
    }
    else{
      _user = widget.contact!.createUserFromContact();
      _user!.getUserInfoFromFirestore().whenComplete((){
        setState(() {
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: Text('View Profiel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(35, 50, 35, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: AutoSizeText(
                      'Hello my name is ${_user!.firstName}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      maxLines: 2,
                    ),
                  ),

                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: MediaQuery.of(context).size.width / 9.5,
                    child: CircleAvatar(
                      backgroundImage: _user!.displayImage,
                      radius: MediaQuery.of(context).size.width / 10,
                    ),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'About Me',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _user!.bio!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'Location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(Icons.home),
                      Padding(
                        padding: const EdgeInsetsGeometry.only(left: 15.0),
                        child: AutoSizeText(
                          'Lives in ${_user!.city}, ${_user!.country}',

                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'Reviews:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsetsGeometry.only(top: 20),
                child: ReviewFormUi(user: _user!,),
              ),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users/${_user!.id}/reviews').snapshots(), 
                builder: (context, snapshots) {
                  if(snapshots.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      Review currentReview = Review();
                      currentReview.getReviewFromFirestore(snapshots.data!.docs[index]);

                      // display reviews using ui design
                      return ReviewDesignTileUi(review: currentReview,);
                    }
                  );
                }
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}