import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('conversations').where('userIDs', arrayContains: AppConstants.currentUser.id).snapshots(),
      builder: (context, snapshots) {
        switch (snapshots.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator(),);
          
          default:
            return ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemExtent: MediaQuery.of(context).size.height / 9,
              itemBuilder: (context, index) {
                DocumentSnapshot snapshot = snapshots.data!.docs[index];
                
              }
            );
        }
      }
    );
  }
}