import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ShowMyPostingListTile extends StatefulWidget {
  final Posting? posting;
  const ShowMyPostingListTile({super.key, this.posting});

  @override
  State<ShowMyPostingListTile> createState() => _ShowMyPostingListTileState();
}

class _ShowMyPostingListTileState extends State<ShowMyPostingListTile> {
  Posting? _posting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _posting = widget.posting;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10.0),
      child: ListTile(
        title: AutoSizeText(
          _posting!.name!,
          maxLines: 2,
          minFontSize: 15.0,
          maxFontSize: 20.0,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: AspectRatio(
          aspectRatio: 3 / 2,
          child: Image(
            image: _posting!.displayImages!.first,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}