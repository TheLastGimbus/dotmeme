import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

// TODO: Deal somehow with those annoying folders from camera
class FoldersSettingsPage extends StatelessWidget {
  // Workaround for now :/
  // This needs to be enough until photo_manager creator will fix
  Future<Map<String, String>> _loadNames() async {
    var assFolders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );
    var names = Map<String, String>();
    for (var ass in assFolders) {
      names[ass.id] = ass.name;
    }
    return names;
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

  Widget _foldersListView(MemesProvider memesProvider, List<Folder> folders) =>
      FutureBuilder(
        future: _loadNames(),
        builder: (context, snapshot) => ListView(
          children: folders
              .map((folder) => SwitchListTile(
                    value: folder.scanningEnabled,
                    title: Text(snapshot.hasData
                        ? snapshot.data[folder.id.toString()]
                        : '...'),
                    onChanged: (enabled) {
                      disableFolder() {
                        // TODO: Add some warning if folder has a lot scanned
                        memesProvider.setFolderSyncEnabled(
                          folder,
                          enabled,
                          deleteIfDisabled: true,
                        );
                      }

                      if (snapshot.hasData &&
                          enabled &&
                          snapshot.data[folder.id.toString()] == "Camera") {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => _cameraWarningDialog(
                            onContinue: (userAgreed) {
                              Navigator.of(context).pop();
                              if (userAgreed) disableFolder();
                            },
                          ),
                        );
                      } else {
                        disableFolder();
                      }
                    },
                  ))
              .toList(),
        ),
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
        child: FutureBuilder(
          future: memesProvider.getAllFolders,
          builder: (ctx, AsyncSnapshot<List<Folder>> snapshot) =>
              snapshot.hasData
                  ? _foldersListView(memesProvider, snapshot.data)
                  : Text('Wait...'),
        ),
      ),
    );
  }
}
