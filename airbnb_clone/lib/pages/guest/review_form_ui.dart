import 'package:airbnb_clone/common/common_functions.dart';
import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/models/user_objects.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';

class ReviewFormUi extends StatefulWidget {
  final Posting? posting;
  final UserModel? user;

  const ReviewFormUi({super.key, this.posting, this.user});

  @override
  State<ReviewFormUi> createState() => _ReviewFormUiState();
}

class _ReviewFormUiState extends State<ReviewFormUi> {
  TextEditingController _controller = new TextEditingController();
  double _rating = 2;

  _saveNewReview() {
    if(widget.posting == null) {
      // review host
       widget.user!.postNewReview(_controller.text, _rating).whenComplete((){
        _controller.text = "";
        _rating = 2.5;
        setState(() {
          
        });

        CommonFunctions.showSnackBar(context, 'Your review has been submitted');
      });
    }
    else{
      // review property
      widget.posting!.postNewReview(_controller.text, _rating).whenComplete((){
        _controller.text = "";
        _rating = 2.5;
        setState(() {
          
        });

        CommonFunctions.showSnackBar(context, 'Your review has been submitted');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'type here ...',
                    ),
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16),
                    controller: _controller,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "please enter some text";
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsGeometry.only(
                          top: 20,
                          bottom: 10,
                        ),
                        child: RatingBar(
                          size: 40,
                          maxRating: 5,
                          initialRating: _rating,
                          filledColor: Colors.green,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          onRatingChanged: (rating) {
                            _rating = rating;
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: MaterialButton(
                          onPressed: _saveNewReview,
                          color: Colors.black,
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
