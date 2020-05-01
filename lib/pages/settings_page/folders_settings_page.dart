import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

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

  Widget _foldersListView(MemesProvider memesProvider, List<Folder> folders) =>
      FutureBuilder(
        future: _loadNames(),
        builder: (context, snapshot) => ListView(
          children: folders
              .map((folder) => SwitchListTile(
                    value: folder.scanningEnabled,
                    title: Text(
                        snapshot.hasData ? snapshot.data[folder.id] : '...'),
                    onChanged: (enabled) {
                      memesProvider.setFolderSyncEnabled(folder, enabled);
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
