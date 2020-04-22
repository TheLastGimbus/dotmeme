import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemesGridView extends StatelessWidget {

  Widget _memeThumbnail(int index, String assetPath) => Hero(
    tag: 'meme$index',
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    ),
  );

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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pushNamed(
                '/swiping_page',
                arguments: SwipingPageRouteData(index),
              );
            },
            child: _memeThumbnail(index, homeProvider.memesList[index]),
          ),
        );
      },
    ));
  }
}
