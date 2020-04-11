import 'package:flutter/widgets.dart';

// This will provide items that are selected

class SelectedItemsProvider with ChangeNotifier {
  List<Object> _selected;

  setSelected(List<String> newList) {
    _selected = newList;
    notifyListeners();
  }

  get getSelected => _selected;
}
