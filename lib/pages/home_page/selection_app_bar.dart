import 'dart:typed_data';

import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

Widget selectionAppBar(BuildContext context) {
  var homeProvider = Provider.of<HomePageProvider>(context);
  return AppBar(
    title: Text('Selected ${homeProvider.selectControl.selection.amount}'),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        homeProvider.selectControl.clear();
      },
    ),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.share), onPressed: () async {
        var memesIds = homeProvider.selectControl.selection.selectedIndexes
            .map((index) => homeProvider.memesList[index].id);
        var bytesMap = Map<String, Uint8List>();
        for(var id in memesIds){
          var asset = await AssetEntity.fromId(id.toString());
          bytesMap[asset.title] = await asset.originBytes;
        }
        Share.files('Share memes', bytesMap, 'image/*');
      },),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          var idsToDelete = homeProvider.selectControl.selection.selectedIndexes
              .map((index) => homeProvider.memesList[index].id.toString())
              .toList();
          PhotoManager.editor.deleteWithIds(idsToDelete);
        },
      ),
      IconButton(icon: Icon(Icons.more_vert)),
    ],
    backgroundColor: Colors.black38,
    brightness: Brightness.dark,
  );
}
