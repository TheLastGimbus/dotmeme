import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/widgets.dart';

class HomePageProvider with ChangeNotifier {
  final _selectControl = DragSelectGridViewController();
  final _searchTextControl = TextEditingController();
  final _searchFocusNode = FocusNode();
  var _memesList = List<String>();

  List<String> get memesList => _memesList;

  DragSelectGridViewController get selectControl => _selectControl;

  TextEditingController get searchTextControl => _searchTextControl;

  FocusNode get searchFocusNode => _searchFocusNode;

  set memesList(List<String> newList) {
    _memesList = newList;
    notifyListeners();
  }

  HomePageProvider() {
    _selectControl.addListener(() {
      notifyListeners();
    });

  }
}
