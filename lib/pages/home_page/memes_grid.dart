import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MemesGrid extends StatefulWidget {
  MemesGrid({@required this.memesList});

  List<String> memesList;

  @override
  _MemesGridState createState() => _MemesGridState(memesList: memesList);
}

class _MemesGridState extends State<MemesGrid> {
  _MemesGridState({@required this.memesList});

  List<String> memesList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: memesList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/swiping_page',
                arguments: SwipingPageRouteData(memesList, index),
              );
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Hero(
                tag: 'meme$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    memesList[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
