import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget searchAppBar(BuildContext context) {
  var textTheme = Theme.of(context).textTheme;
  var homeProvider = Provider.of<HomePageProvider>(context);
  return AppBar(
    title: TextField(
      textInputAction: TextInputAction.search,
      focusNode: homeProvider.searchFocusNode,
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration.collapsed(
        hintText: 'Search',
        hintStyle: textTheme.title.copyWith(color: Colors.white),
      ),
      controller: homeProvider.searchTextControl,
      cursorColor: Colors.white,
      style: textTheme.body1.copyWith(color: Colors.white),
      onSubmitted: (input) {
        print('entered $input');
        FocusScope.of(context).unfocus();
      },
    ),
    actions: [
      AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            ScaleTransition(child: child, scale: animation),
        child: homeProvider.searchTextControl.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  homeProvider.searchTextControl.clear();
                },
              )
            : SizedBox(),
      )
    ],
  );
}
