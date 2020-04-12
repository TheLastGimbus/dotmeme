import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchFocusNode = FocusNode();
  final controller = DragSelectGridViewController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    selectControl.dispose();
    searchTextControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memesProvider = Provider.of<MemesProvider>(context);
    var memesList = memesProvider.getAllMemes;

    return Scaffold(
      appBar: controller.selection.isSelecting
          ? AppBar(
              title: Text('Selected ${controller.selection.amount}'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  controller.selection = Selection(Set());
                },
              ),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.share)),
                IconButton(icon: Icon(Icons.delete)),
                IconButton(icon: Icon(Icons.more_vert)),
              ],
              backgroundColor: Colors.black38,
              brightness: Brightness.dark,
            )
          : AppBar(
              title: TextField(
                textInputAction: TextInputAction.search,
                focusNode: searchFocusNode,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration.collapsed(hintText: 'Search'),
                cursorColor: Colors.white,
                onSubmitted: (input) {
                  print('entered $input');
                  FocusScope.of(context).dispose();
                },
              ),
            ),
      body: DragSelectGridView(
        itemCount: memesList.length,
        gridController: controller,
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
              onTap: controller.selection.isSelecting
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
                  borderRadius: BorderRadius.circular(10),
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
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {
          FocusScope.of(context).requestFocus(searchFocusNode);
        },
      ),
    );
  }
}
