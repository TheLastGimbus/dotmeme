import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class _AssetData {
  final File file;
  final String title;

  _AssetData(this.file, this.title);
}

class FileInfo extends StatelessWidget {
  final String assetId;

  const FileInfo({Key key, @required this.assetId}) : super(key: key);

  Future<_AssetData> _loadAssetData(String id) async {
    var ass = await AssetEntity.fromId(assetId);
    ass.refreshProperties();
    return _AssetData(await ass.file, ass.title);
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
            ],
          );
        },
      ),
    );
  }
}
