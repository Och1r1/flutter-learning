import 'package:airbnb_clone/pages/host/create_update_posting_page.dart';
import 'package:airbnb_clone/widgets/create_postings_list_tile_button.dart';
import 'package:flutter/material.dart';

class MyPostingsPage extends StatefulWidget {
  const MyPostingsPage({super.key});

  @override
  State<MyPostingsPage> createState() => _MyPostingsPageState();
}

class _MyPostingsPageState extends State<MyPostingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(25, 0, 25, 25),
      child: InkResponse(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUpdatePostingPage(posting: null,)));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: CreatePostingsListTileButton(),
        )
      ),
    );
  }
}