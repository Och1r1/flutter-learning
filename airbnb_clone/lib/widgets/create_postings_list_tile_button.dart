import 'package:flutter/material.dart';

class CreatePostingsListTileButton extends StatelessWidget {
  const CreatePostingsListTileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 12,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          Text(
            'Create a Listing',
            style: TextStyle(
              fontSize: 21,
            ),
          )
        ],
      ),
    );
  }
}