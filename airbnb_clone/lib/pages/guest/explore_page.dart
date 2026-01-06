import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/pages/guest/view_posting_page.dart';
import 'package:airbnb_clone/widgets/posting_grid_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  final TextEditingController _controller = TextEditingController();
  String searchText = '';


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(25, 15, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => {
                setState(() {
                  searchText = value.toLowerCase();
                }),
              },
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search by place name, city, property type, ...',
                hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38, width: 1.2),
                  borderRadius: BorderRadius.circular(8),
                )
              ),
            ),

            const SizedBox(height: 20,),

            // display ALL Postings - 

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('postings').snapshots(),

                builder: (context, snapshots){
                  if(!snapshots.hasData){
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allDocs = snapshots.data!.docs;

                  final docs = searchText.isEmpty
                    ? allDocs
                    : allDocs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        final name = (data['name'] ?? '').toString().toLowerCase();
                        final type = (data['type'] ?? '').toString().toLowerCase();
                        final address = (data['address'] ?? '').toString().toLowerCase();
                        final city = (data['city'] ?? '').toString().toLowerCase();

                        return name.contains(searchText) ||
                              type.contains(searchText) ||
                              address.contains(searchText) ||
                              city.contains(searchText);
                      }).toList();



                  if(docs.isEmpty){
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'No results found',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 15,
                      childAspectRatio: 3 / 4,
                    ),

                    itemBuilder: (context, index){
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final posting = Posting(id: doc.id);
                      posting.getPostingInfoFromSnapshot(doc);

                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPostingPage(posting: posting)));
                        },
                        child: PostingGridTile(posting: posting),
                      );
                    },
                  );
                },
            ),

          ],
        ),
      ),
    );
  }
}