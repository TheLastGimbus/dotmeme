import 'dart:typed_data';

import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

Widget selectionAppBar(BuildContext context) {
  var homeProvider = Provider.of<HomePageProvider>(context);
  var memesProvider = Provider.of<MemesProvider>(context);

  return AppBar(
    title: Text('Selected ${homeProvider.selectControl.value.amount}'),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        homeProvider.selectControl.clear();
      },
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.share),
        onPressed: () async {
          var memesIds = homeProvider.selectControl.value.selectedIndexes
              .map((index) => homeProvider.memesList[index].id);
          var bytesMap = Map<String, Uint8List>();
          for (var id in memesIds) {
            var asset = await AssetEntity.fromId(id.toString());
            bytesMap[asset.title] = await asset.originBytes;
          }
          // TODO: Need to change from 'image/*' to something else
          // when I introduce videos
          Share.files('Share memes', bytesMap, 'image/*');
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          var selectedMemes = homeProvider.selectControl.value.selectedIndexes
              .map((index) => homeProvider.memesList[index]);
          var idsToDelete = selectedMemes.map((m) => m.id.toString());
          PhotoManager.editor.deleteWithIds(idsToDelete.toList());
          memesProvider.deleteMemes(selectedMemes.toList());
          homeProvider.memesList = await memesProvider.getAllMemes;
          homeProvider.selectControl.clear();
        },
      ),
      IconButton(icon: Icon(Icons.more_vert)),
    ],
    backgroundColor: Colors.black38,
    brightness: Brightness.dark,
  );
}
