// This provider keeps sync of all memes list
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

class MemesProvider with ChangeNotifier {
  Future<List<AssetEntity>> get getAllMemes async {
    var folders = await PhotoManager.getAssetPathList(type: RequestType.image);
    return folders[0].assetList;
  }
}
