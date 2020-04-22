import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget searchAppBar(BuildContext context) {
  var textTheme = Theme.of(context).textTheme;
  var homeProvider = Provider.of<HomePageProvider>(context);
  return AppBar(
    title: TextField(
      textInputAction: TextInputAction.search,
      focusNode: homeProvider.searchFocusNode, // TODO
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration.collapsed(
          hintText: 'Search',
          hintStyle: textTheme.title.copyWith(color: Colors.white)),
      controller: TextEditingController(), // TODO
      cursorColor: Colors.white,
      style: textTheme.body1.copyWith(color: Colors.white),
      onChanged: (input) {
        // TODO: Show/hide "discard text" button
      },
      onSubmitted: (input) {
        print('entered $input');
        // TODO: focus.unfocus();
      },
    ),
    actions: [
      AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            ScaleTransition(child: child, scale: animation),
        child: false // TODO: When user typing
            ? IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // TODO: Clear text
          },
        )
            : SizedBox(),
      )
    ],
  );
}