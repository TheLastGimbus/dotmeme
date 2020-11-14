import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Widget _CopyText(
  String text, {
  VoidCallback onPressed,
  VoidCallback onLongPress,
}) =>
    InkWell(
      child: Text(text),
      onTap: onPressed ?? () {},
      onLongPress: onLongPress ??
          () async {
            await Clipboard.setData(ClipboardData(text: text));
          },
    );

class FileInfo extends StatelessWidget {
  final String assetId;

  const FileInfo({Key key, @required this.assetId}) : super(key: key);

  Future<_AssetData> _loadAssetData(String id) async {
    var ass = await AssetEntity.fromId(assetId);
    await ass.refreshProperties();
    var file = await ass.file;
    return _AssetData(
      file,
      ass.title,
      ass.relativePath,
      await file.length(),
      ass.size,
      ass.createDateTime,
      ass.modifiedDateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double spacing = 8;

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
              _CopyText(data.title),
              SizedBox(height: spacing),
              Text('File path:', style: theme.textTheme.bodyText1),
              // TODO: Change this when chinese guy fixes it
              _CopyText(data.file.path),
              SizedBox(height: spacing),
              Text('Size:', style: theme.textTheme.bodyText1),
              _CopyText(filesize(data.bytes)),
              SizedBox(height: spacing),
              Text('Resolution:', style: theme.textTheme.bodyText1),
              _CopyText(
                data.size.width.round().toString() +
                    'x' +
                    data.size.height.round().toString(),
              ),
              SizedBox(height: spacing),
              Text('Creation date:', style: theme.textTheme.bodyText1),
              _CopyText(data.createDateTime.toString()),
              SizedBox(height: spacing),
              Text('Modification date:', style: theme.textTheme.bodyText1),
              _CopyText(data.modifiedDateTime.toString()),
              SizedBox(height: spacing),
            ],
          );
        },
      ),
    );
  }
}
