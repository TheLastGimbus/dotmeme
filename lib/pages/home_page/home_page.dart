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
  // TODO: Clear textField focus when keyboard hidden by back press
  final searchFocusNode = FocusNode();
  final selectControl = DragSelectGridViewController();
  final searchTextControl = TextEditingController();
  var _userTyping = false;

  @override
  void initState() {
    super.initState();
    selectControl.addListener(() {
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
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var focus = FocusScope.of(context);

    return Scaffold(
      appBar: selectControl.selection.isSelecting
          ? AppBar(
              title: Text('Selected ${selectControl.selection.amount}'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  selectControl.selection = Selection(Set());
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
                decoration: InputDecoration.collapsed(
                    hintText: 'Search',
                    hintStyle: textTheme.title.copyWith(color: Colors.white)),
                controller: searchTextControl,
                cursorColor: Colors.white,
                style: textTheme.body1.copyWith(color: Colors.white),
                onChanged: (input) {
                  var tmp = input.length > 0;
                  if (tmp != _userTyping) {
                    setState(() {
                      _userTyping = tmp;
                    });
                  }
                },
                onSubmitted: (input) {
                  print('entered $input');
                  focus.unfocus();
                },
              ),
              actions: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(child: child, scale: animation),
                  child: _userTyping
                      ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              searchTextControl.clear();
                              _userTyping = false;
                            });
                          },
                        )
                      : SizedBox(),
                )
              ],
            ),
      body: DragSelectGridView(
        itemCount: memesList.length,
        gridController: selectControl,
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
              onTap: selectControl.selection.isSelecting
                  ? null
                  : () {
                      focus.unfocus();
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
      drawer: Drawer(
        // TODO: Make this apear only on debug config
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Dev - quick scan'),
              onTap: () {
                Navigator.of(context).pushNamed('/testing_page');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {
          if (focus.hasFocus) {
            focus.unfocus();
          }
          focus.requestFocus(searchFocusNode);
        },
      ),
    );
  }
}
