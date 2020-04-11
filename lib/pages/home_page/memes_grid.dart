import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MemesGrid extends StatefulWidget {
  MemesGrid({@required this.memesList, this.onSelectionModeChange});

  List<String> memesList;
  final VoidCallback onSelectionModeChange;

  @override
  _MemesGridState createState() => _MemesGridState(memesList: memesList);
}

class _MemesGridState extends State<MemesGrid> {
  _MemesGridState({@required this.memesList, this.onSelectionModeChange});

  List<String> memesList;
  final VoidCallback onSelectionModeChange;
  final controller = DragSelectGridViewController();

  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _selectionMode = controller.selection.amount > 0;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Consider flutter_staggered_grid_view package
      child: DragSelectGridView(
        itemCount: memesList.length,
        gridController: controller,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index, selected) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 150),
            decoration: selected
                ? BoxDecoration(color: Theme
                .of(context)
                .primaryColor
                .withOpacity(0.3))
                : BoxDecoration(),
            padding: EdgeInsets.all(selected ? 12 : 3),
            child: GestureDetector(
              onTap: _selectionMode
                  ? null
                  : () {
                Navigator.of(context).pushNamed(
                  '/swiping_page',
                  arguments: SwipingPageRouteData(memesList, index),
                );
              },
              child: Hero(
                tag: 'meme$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    memesList[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
