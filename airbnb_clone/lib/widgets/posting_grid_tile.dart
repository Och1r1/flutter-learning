import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';

class PostingGridTile extends StatefulWidget {
  final Posting? posting;

  const PostingGridTile({super.key, this.posting});

  @override
  State<PostingGridTile> createState() => _PostingGridTileState();
}

class _PostingGridTileState extends State<PostingGridTile> {
  Posting? _posting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _posting = widget.posting;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _posting!.getFirstImageFromStorage(),

      ]), 
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done){
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 3/2,
              child: (_posting!.displayImages!.isEmpty)
                ? Container()
                : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _posting!.displayImages!.first,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            ),
            AutoSizeText(
              "${_posting!.type} - ${_posting!.city}, ${_posting!.country}",
              maxLines: 2,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                _posting!.name!,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ' 💲 ${_posting!.price!} / night',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            Row(
              children: [
                RatingBar.readOnly(
                  size: 28.0,
                  maxRating: 5,
                  initialRating: _posting!.getCurrentRating(),
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  filledColor: AppConstants.selectedIcon,
                  isHalfAllowed: true,
                  halfFilledIcon: Icons.star_half,
                  halfFilledColor: Colors.white,
                ),
                const SizedBox(width: 5,),
                Text(
                  _posting!.reviews!.isEmpty
                    ? '5.0'
                    : "${_posting!.getCurrentRating().toStringAsFixed(1)}",
                    style: const TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}