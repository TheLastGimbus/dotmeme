import 'package:dotmeme/pages/home_page/memes_grid.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          focusNode: searchFocusNode,
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration.collapsed(hintText: 'Search'),
          cursorColor: Colors.white,
          onSubmitted: (input) {
            print('entered $input');
            FocusScope.of(context).dispose();
          },
        ),
      ),
      body:
      MemesGrid(memesList: Provider
          .of<MemesProvider>(context)
          .getAllMemes),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {
          FocusScope.of(context).requestFocus(searchFocusNode);
        },
      ),
    );
  }
}
