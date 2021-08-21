import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, this.onChanged, this.onSubmitted})
      : super(key: key);
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final ctrl = TextEditingController();
  var _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: TextField(
          controller: ctrl,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: AnimatedSwitcher(
                child: _isEmpty
                    ? const Icon(Icons.search, key: ValueKey('search'))
                    : const Icon(Icons.close, key: ValueKey('close')),
                duration: const Duration(milliseconds: 200),
              ),
              onPressed: () {
                if (ctrl.text.isNotEmpty) {
                  ctrl.clear();
                  setState(() => _isEmpty = true);
                  if (widget.onChanged != null) widget.onChanged!("");
                  if (widget.onChanged != null) widget.onSubmitted!("");
                }
              },
            ),
          ),
          textInputAction: TextInputAction.search,
          onChanged: (txt) {
            if (txt.isEmpty != _isEmpty) {
              setState(() => _isEmpty = txt.isEmpty);
            }
            if (widget.onChanged != null) widget.onChanged!(txt);
          },
          onSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }
}
