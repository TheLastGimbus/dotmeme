import 'package:dotmeme/pages/home_page/memes_grid_view.dart';
import 'package:dotmeme/pages/home_page/search_app_bar.dart';
import 'package:dotmeme/pages/home_page/selection_app_bar.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:watcher/watcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: Clear textField focus when keyboard hidden by back press

  // +++++ NOW +++++
  // TODO: Sync when changing settings
  // +++++ NOW +++++

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

      // Add file watchers
      for (var folder in await memesProvider.getAllFolders) {
        var assPath = await AssetPathEntity.fromId(folder.id.toString());
        var singleAss =
            (await assPath.getAssetListRange(start: 0, end: 1)).first;
        if (singleAss == null) continue;
        var file = await singleAss.file;

        var newSyncGoing = false;
        var newSyncScheduled = false;
        var deleteSyncGoing = false;
        var deleteSyncScheduled = false;

        newSync() async {
          if (newSyncGoing) {
            newSyncScheduled = true;
            return;
          }
          newSyncGoing = true;
          print('NewSync running...');
          await memesProvider.syncNewMemesInFolder(folder.id);
          homeProvider.memesList = await memesProvider.getAllMemes;
          newSyncGoing = false;
          if (newSyncScheduled) {
            newSyncScheduled = false;
            newSync();
          }
        }

        deleteSync() async {
          if (deleteSyncGoing) {
            deleteSyncScheduled = true;
            return;
          }
          deleteSyncGoing = true;
          print('DeleteSync running...');
          await memesProvider.syncDeletedMemesInFolder(folder.id);
          homeProvider.memesList = await memesProvider.getAllMemes;
          deleteSyncGoing = false;
          if (deleteSyncScheduled) {
            deleteSyncScheduled = false;
            deleteSync();
          }
        }

        var watcher = DirectoryWatcher(file.parent.path);
        watcher.events.listen((event) async {
          print(event);
          if (event.type == ChangeType.ADD) {
            newSync();
          } else if (event.type == ChangeType.REMOVE) {
            deleteSync();
          } else {
            newSync();
            deleteSync();
          }
        });
      }

      await memesProvider.syncMemes();
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
