import 'package:flutter/material.dart';
import 'storybrain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: StoryPage(),
          ),
        ),
      ),
    );
  }
}

StoryBrain storyBrain = StoryBrain();

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});
  
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 12,
          child: Center(
            child: Text(
              storyBrain.getStory(),
              style: TextStyle(fontSize: 25.0, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextButton(
              onPressed: () => setState(() {
                storyBrain.nextStory(1);
              }),
              style: TextButton.styleFrom(
                shape: BeveledRectangleBorder(),
                backgroundColor: Colors.red,
              ),
              child: Text(
                storyBrain.getChoice1(),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Visibility(
              visible: storyBrain.isEnd(),
              child: TextButton(
                onPressed: () => setState(() {
                  storyBrain.nextStory(2);
                }),
                style: TextButton.styleFrom(
                  shape: BeveledRectangleBorder(),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  storyBrain.getChoice2(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40.0),
      ],
    );
  }
}
