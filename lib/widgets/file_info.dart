import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class _AssetData {
  final File file;
  final String title;
  final String path;
  final int bytes;
  final Size size;
  final DateTime createDateTime;
  final DateTime modifiedDateTime;

  _AssetData(
    this.file,
    this.title,
    this.path,
    this.bytes,
    this.size,
    this.createDateTime,
    this.modifiedDateTime,
  );
}

class FileInfo extends StatelessWidget {
  final String assetId;

  const FileInfo({Key key, @required this.assetId}) : super(key: key);

  Future<_AssetData> _loadAssetData(String id) async {
    var ass = await AssetEntity.fromId(assetId);
    await ass.refreshProperties();
    var file = await ass.file;
    return _AssetData(file, ass.title, ass.relativePath, await file.length(),
        ass.size, ass.createDateTime, ass.modifiedDateTime);
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
              // TODO: Change this when chinese guy fixes it
              Text('  ' + data.file.path),
              SizedBox(height: 6),
              Text('Size:', style: theme.textTheme.bodyText1),
              Text('  ' + filesize(data.bytes)),
              SizedBox(height: 6),
              Text('Resolution:', style: theme.textTheme.bodyText1),
              Text(
                '  ' +
                    data.size.width.round().toString() +
                    'x' +
                    data.size.height.round().toString(),
              ),
              SizedBox(height: 6),
            ],
          );
        },
      ),
    );
  }
}
