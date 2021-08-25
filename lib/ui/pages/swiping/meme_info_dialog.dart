import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog with info about meme
/// If [onLongPress] in given [MemeProperty] will be null, it will be copied to
/// clipboard. If you want to disable this, just pass it an empty function
class MemeInfoDialog extends StatelessWidget {
  final List<MemeProperty> properties;

  const MemeInfoDialog({Key? key, required this.properties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Properties"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final p in properties)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: _property(context, p),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Ok"),
        ),
      ],
    );
  }

  Widget _property(BuildContext context, MemeProperty prop) {
    final th = Theme.of(context);
    return GestureDetector(
      onTap: prop.onTap,
      onLongPress: prop.onLongPress ??
          () {
            Clipboard.setData(ClipboardData(text: prop.value));
            final msg = ScaffoldMessenger.of(context);
            msg.hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
            msg.showSnackBar(
              SnackBar(
                content: Text("Copied ${prop.name} to clipboard!"),
                action: SnackBarAction(
                  label: "Ok",
                  onPressed: () => msg.hideCurrentSnackBar(
                      reason: SnackBarClosedReason.action),
                ),
              ),
            );
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(prop.name, style: th.textTheme.caption),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(prop.value ?? "<unknown>"),
          ),
        ],
      ),
    );
  }
}

class MemeProperty {
  final String name;
  final String? value;
  final Function()? onTap;
  final Function()? onLongPress;

  MemeProperty({
    required this.name,
    required this.value,
    this.onTap,
    this.onLongPress,
  });
}
