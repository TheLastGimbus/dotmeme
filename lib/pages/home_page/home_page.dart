import 'package:dotmeme/pages/home_page/memes_grid_view.dart';
import 'package:dotmeme/pages/home_page/search_app_bar.dart';
import 'package:dotmeme/pages/home_page/selection_app_bar.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: Clear textField focus when keyboard hidden by back press
  final fim = FimberLog("HomePage");

  // TODO: Make this a shared pref
  var crossAxisCount = 3;

  /// This keeps track of how much change crossAxisCount according to how much
  /// scale from user gesture has changed
  int _scaleHop = 0;

  void onMemesUpdate(HomePageProvider home, MemesProvider memes) async {
    home.memesList = await memes.getAllMemes;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var homeProvider = Provider.of<HomePageProvider>(context, listen: false);
      var memesProvider = Provider.of<MemesProvider>(context, listen: false);
      onMemesUpdate() async {
        homeProvider.memesList = await memesProvider.getAllMemes;
      }

      onMemesUpdate();
      memesProvider.addListener(onMemesUpdate);

      await memesProvider.syncMemes();
      await memesProvider.syncFolders();
      memesProvider.setupWatchers();
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
      appBar: homeProvider.selectControl.value.isSelecting
          ? selectionAppBar(context)
          : searchAppBar(context),
      body: GestureDetector(
        onScaleUpdate: (det) {
          // The code here executes the code of ++'ing the crossAxisCount
          // only when a certain threshold of scale has been reached.
          // Let's say that the user is scaling down with his fingers
          // 1. He starts scaling. _scaleHop is 0 by default, so when only
          // GestureDetector will detect that, code below "if" will execute
          // and "--" the _scaleHop - so now it's -1
          // 2. User keeps moving fingers. But now, det.scale needs to be lower
          // than 1+(-1*0.6) == 0.4.
          // 3. Scale reaches 0.4, code inside if executes, _scaleHop is --'ed
          // again, and now...
          // 4. Scaling would need to reach 1+(-2*0.6) == -0.8 -
          // to execute again - scaling goes from 1 to 0, so it's impossible
          // Note: this comments may be outdated if I set values
          // (_scaleHop * value) different - it was 0.6 for scaling down - but
          // you can get the idea of what's happening in here
          if (det.scale < 1 + (_scaleHop * 0.6)) {
            _scaleHop--;
            crossAxisCount++;
            if (crossAxisCount > 7) crossAxisCount = 7;
            setState(() {});
          }
          if (det.scale > 1 + (_scaleHop * 0.3)) {
            _scaleHop++;
            crossAxisCount--;
            if (crossAxisCount < 2) crossAxisCount = 2;
            setState(() {});
          }
          // I'm watching jbzd.com.pl on my math e-learning lessons, so I don't
          // know how to do some nice calculations that would set the thresholds
          // nicely, but this satisfies me for now
        },
        onScaleEnd: (_) => _scaleHop = 0,
        child: MemesGridView(crossAxisCount: crossAxisCount),
      ),
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
