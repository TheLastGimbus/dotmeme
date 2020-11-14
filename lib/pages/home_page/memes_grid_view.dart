import 'dart:typed_data';

import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class MemesGridView extends StatelessWidget {
  Future<Uint8List> _loadThumb(String assetId,
      {int width = 150, int height = 150, int quality = 70}) async {
    var ass = await AssetEntity.fromId(assetId);
    return ass.thumbDataWithSize(width, height, quality: quality);
  }

  Widget _memeThumbnail(BuildContext context, int index, Uint8List thumb) {
    var homeProvider = Provider.of<HomePageProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: GestureDetector(
        onTap: homeProvider.selectControl.value.isSelecting
            ? null
            : () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pushNamed(
                  '/swiping_page',
                  arguments: SwipingPageRouteData(
                    startIndex: index,
                    startThumbnail: thumb,
                  ),
                );
              },
        child: Image.memory(
          thumb,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomePageProvider>(context);
    var mq = MediaQuery.of(context);
    // TODO: Replace by other way to know how many crossAxisCount we have
    var thumbSize = (mq.size.width / 3).round();

    return Container(
      child: DragSelectGridView(
        itemCount: homeProvider.memesList.length,
        gridController: homeProvider.selectControl,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index, selected) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 150),
            decoration: selected
                ? BoxDecoration(
                    color: Theme.of(context).primaryColorLight.withOpacity(0.5))
                : BoxDecoration(),
            padding: EdgeInsets.all(selected ? 12 : 3),
            child: FutureBuilder(
              future: _loadThumb(
                homeProvider.memesList[index].id.toString(),
                width: thumbSize,
                height: thumbSize,
                quality: 50, // TODO: Test how much performence it affects
              ),
              builder: (ctx, snapshot) => snapshot.hasData
                  ? _memeThumbnail(context, index, snapshot.data)
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
