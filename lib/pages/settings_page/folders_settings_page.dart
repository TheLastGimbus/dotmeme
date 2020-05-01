import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget _foldersListView(List<Folder> folders) => ListView(
      children: folders
          .map((folder) => SwitchListTile(
                value: folder.scanningEnabled,
                // This needs to be enough until photo_manager creator will fix
                // TODO: Change this to get folder name
                title: Text(folder.id),
                // TODO: onChanged
              ))
          .toList(),
    );

class FoldersSettingsPage extends StatelessWidget {
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
                  ? _foldersListView(snapshot.data)
                  : Text('Wait...'),
        ),
      ),
    );
  }
}
