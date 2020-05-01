import 'package:dotmeme/pages/home_page/memes_grid_view.dart';
import 'package:dotmeme/pages/home_page/search_app_bar.dart';
import 'package:dotmeme/pages/home_page/selection_app_bar.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: Clear textField focus when keyboard hidden by back press

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      var homeProvider = Provider.of<HomePageProvider>(context, listen: false);
      var memesProvider = Provider.of<MemesProvider>(context, listen: false);
      memesProvider.getAllMemes.then((memes) => homeProvider.memesList = memes);

      memesProvider.addListener(() {
        memesProvider.getAllMemes
            .then((memes) => homeProvider.memesList = memes);
      });
    });
  }

  Widget navigationDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            // TODO: Make this appear only on debug config
            ListTile(
              title: Text('Dev - quick scan'),
              onTap: () {
                Navigator.of(context).pushNamed('/testing_page');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pushNamed('/settings_page');
              },
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomePageProvider>(context);

    return Scaffold(
      appBar: homeProvider.selectControl.selection.isSelecting
          ? selectionAppBar(context)
          : searchAppBar(context),
      body: MemesGridView(),
      drawer: navigationDrawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {
          var focus = FocusScope.of(context);
          focus.unfocus();
          focus.requestFocus(homeProvider.searchFocusNode);
        },
      ),
    );
  }
}
