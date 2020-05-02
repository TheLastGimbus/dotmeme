import 'package:dotmeme/database/memebase.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

class HomePageProvider with ChangeNotifier {
  final _selectControl = DragSelectGridViewController();
  final _searchTextControl = TextEditingController();
  final _searchFocusNode = FocusNode();
  var _memesList = List<Meme>();

  List<Meme> get memesList => _memesList;

  DragSelectGridViewController get selectControl => _selectControl;

  TextEditingController get searchTextControl => _searchTextControl;

  FocusNode get searchFocusNode => _searchFocusNode;

  set memesList(List<Meme> newList) {
    _memesList = newList;
    notifyListeners();
  }

  HomePageProvider() {
    _selectControl.addListener(() {
      notifyListeners();
    });
  }
}
