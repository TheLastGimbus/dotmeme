import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';

class MemesGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DragSelectGridView(
      itemCount: 0, // TODO
      gridController: DragSelectGridViewController(), // TOOD
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
              Navigator.of(context).pushNamed(
                '/swiping_page',
                arguments: SwipingPageRouteData(
                    ['assets/example_memes/the-cpu.png'], 0), // TODO
              );
            },
            child: Hero(
              tag: 'meme$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/example_memes/the-cpu.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
