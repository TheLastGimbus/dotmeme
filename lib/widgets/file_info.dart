import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class _AssetData {
  final File file;
  final String title;
  final int bytes;

  _AssetData(this.file, this.title, this.bytes);
}

class FileInfo extends StatelessWidget {
  final String assetId;

  const FileInfo({Key key, @required this.assetId}) : super(key: key);

  Future<_AssetData> _loadAssetData(String id) async {
    var ass = await AssetEntity.fromId(assetId);
    ass.refreshProperties();
    var file = await ass.file;
    return _AssetData(file, ass.title, await file.length());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: FutureBuilder(
        future: _loadAssetData(assetId),
        builder: (BuildContext ctx, AsyncSnapshot<_AssetData> snap) {
          if (!snap.hasData) return Text('Wait...');
          if (snap.hasError)
            return Text('Sorry, error occured when reading file data');
          var data = snap.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title:', style: theme.textTheme.bodyText1),
              Text('  ' + data.title),
              SizedBox(height: 6),
              Text('File path:', style: theme.textTheme.bodyText1),
              Text('  ' + data.file.path),
              SizedBox(height: 6),
              Text('Size:', style: theme.textTheme.bodyText1),
              Text('  ' + filesize(data.bytes)),
              SizedBox(height: 6),
            ],
          );
        },
      ),
    );
  }
}
