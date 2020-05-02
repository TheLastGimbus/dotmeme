import 'dart:typed_data';

import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class MemesGridView extends StatelessWidget {
  Widget _memeThumbnail(
      BuildContext context, int index, AssetEntity assetEntity) {
    var homeProvider = Provider.of<HomePageProvider>(context);
    // TODO: There is weird flicker when coming back from swiping
    return Hero(
      tag: 'meme$index',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder(
            future: assetEntity.thumbDataWithSize(150, 150, quality: 35),
            builder: (context, AsyncSnapshot<Uint8List> snapshot) =>
                snapshot.hasData
                    ? GestureDetector(
                        onTap: homeProvider.selectControl.selection.isSelecting
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pushNamed(
                                  '/swiping_page',
                                  arguments: SwipingPageRouteData(
                                    startIndex: index,
                                    startThumbnail: snapshot.data,
                                  ),
                                );
                              },
                        child: Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      )
                    : SizedBox()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomePageProvider>(context);

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
            future:
                AssetEntity.fromId(homeProvider.memesList[index].id.toString()),
            builder: (ctx, snapshot) => snapshot.hasData
                ? _memeThumbnail(context, index, snapshot.data)
                : SizedBox(),
          ),
        );
      },
    ));
  }
}
