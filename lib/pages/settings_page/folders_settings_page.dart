import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class _FolderData {
  final Folder folder;
  final String name;
  final int assetCount;

  _FolderData(this.folder, this.name, this.assetCount);
}

// TODO: Deal somehow with those annoying folders from camera
// Sorting from biggest to smallest kinda solves this?
class FoldersSettingsPage extends StatelessWidget {
  Future<List<_FolderData>> _loadFoldersData(MemesProvider memesP) async {
    await memesP.syncFolders();
    var allDbFolders = await memesP.getAllFolders;

    // Before you ask - it seems to be more efficient to load
    // *all* "AssetFolder"s, and then cherry pick one, instead of loading each
    // one by id. Here you have it - Android :)
    var assFolders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );

    return allDbFolders.map(
      (e) {
        var af = assFolders.firstWhere((ass) => ass.id == e.id.toString());
        return _FolderData(e, af.name, af.assetCount);
      },
    ).toList()
      ..sort(
        (a, b) => b.assetCount.compareTo(a.assetCount),
      );
  }

  AlertDialog _tooltipDialog() => AlertDialog(
        title: Text('Folders settings'),
        content: Text(
          'Select which folders have memes. '
          'Memes in those folders will show on main screen, '
          'and will be scanned, so you can search through them. \n\n'
          'DO NOT select your Camera folder here - it will only '
          'waste space on home screen, and time on scanning.',
        ),
      );

  AlertDialog _cameraWarningDialog({Function(bool) onContinue}) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text(
          'Camera folder contains photos - not memes. '
          'They will take very long to scan, '
          'and will make browsing memes less fun :(',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Yup, I'm sure"),
            onPressed: () => onContinue(true),
          ),
          RaisedButton(
            child: Text('Hell no!'),
            onPressed: () => onContinue(false),
          ),
        ],
      );

  AlertDialog _lotScannedWarningDialog({Function(bool) onContinue}) =>
      AlertDialog(
        title: Text('This folder has a lot of scanned memes!'),
        content: Text(
          'All meme data will be removed, and you will have to scan them again, '
          'if you want to search them! Are you sure you want to disable it? ',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes, they are not funny'),
            onPressed: () => onContinue(true),
          ),
          RaisedButton(
            child: Text('No, keep them!'),
            onPressed: () => onContinue(false),
          ),
        ],
      );

  Widget _folderSwitchTile(BuildContext context, MemesProvider memesProvider,
      Folder folder, String folderName, int assetCount) {
    return SwitchListTile(
      value: folder.scanningEnabled,
      title: Text(folderName),
      subtitle: Text(assetCount.toString()),
      onChanged: (enabled) {
        // If folder is really large, there will be a little lag
        // on switch. Although user will touch this, like,
        // 1-3 times in his/her life. So maybe bother with this
        // some day if you are really bored
        safeToggleFolder() async {
          if (!enabled &&
              await memesProvider.getScannedMemesCount(folder.id) >= 30) {
            showDialog(
              context: context,
              builder: (context) => _lotScannedWarningDialog(
                onContinue: (delete) {
                  Navigator.of(context).pop();
                  if (delete)
                    memesProvider.setFolderSyncEnabled(
                      folder,
                      enabled,
                      deleteIfDisabled: true,
                    );
                },
              ),
            );
          } else
            memesProvider.setFolderSyncEnabled(
              folder,
              enabled,
              deleteIfDisabled: true,
            );
        }

        if (enabled && folderName == "Camera") {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => _cameraWarningDialog(
              onContinue: (userAgreed) {
                Navigator.of(context).pop();
                if (userAgreed) safeToggleFolder();
              },
            ),
          );
        } else
          safeToggleFolder();
      },
    );
  }

  Widget _foldersListView(MemesProvider memesProvider) =>
      FutureBuilder(
        future: _loadFoldersData(memesProvider),
        builder: (context, AsyncSnapshot<List<_FolderData>> snapshot) =>
        snapshot.hasData
            ? ListView(
          children: [
            for (var data in snapshot.data)
              _folderSwitchTile(
                context,
                memesProvider,
                data.folder,
                data.name,
                data.assetCount,
              )
          ],
        )
            : Text('...'),
      );

  @override
  Widget build(BuildContext context) {
    var memesProvider = Provider.of<MemesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => _tooltipDialog(),
            ),
          ),
        ],
      ),
      body: Center(
        child: _foldersListView(memesProvider),
      ),
    );
  }
}
