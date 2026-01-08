import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:airbnb_clone/models/messaging_objects.dart';

class MessageListTileUi extends StatelessWidget {
  final Message? message;
  const MessageListTileUi({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if(message!.sender!.firstName == AppConstants.currentUser!.firstName){
      return Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(15, 15, 35, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.white24,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          message!.text!,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                      ),
                      Align(
                        alignment: AlignmentGeometry.bottomRight,
                        child: Text(
                          message!.getMessageDateTime(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ),
            GestureDetector(
              onTap: () {
                
              },
              child: CircleAvatar(
                backgroundImage: AppConstants.currentUser.displayImage,
                radius: MediaQuery.of(context).size.width / 20,
              ),
            )
          ],
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(15, 15, 35, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                
              },
              child: CircleAvatar(
                backgroundImage: AppConstants.currentUser.displayImage,
                radius: MediaQuery.of(context).size.width / 20,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.green.withAlpha(55),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          message!.text!,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                      ),
                      Align(
                        alignment: AlignmentGeometry.bottomRight,
                        child: Text(
                          message!.getMessageDateTime(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      );
    }
  }
}