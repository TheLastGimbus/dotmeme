import 'package:flutter/gestures.dart';
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
      contentPadding: const EdgeInsets.all(12.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final p in properties)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: _Property(p),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Ok"),
        ),
      ],
    );
  }
}

// Needs to be stateful because of expandable text :+1:
class _Property extends StatefulWidget {
  final MemeProperty property;

  const _Property(this.property, {Key? key}) : super(key: key);

  @override
  _PropertyState createState() => _PropertyState();
}

class _PropertyState extends State<_Property> {
  static const _longCharCount = 100;
  var showLong = false;

  bool isLong(String text) =>
      text.allMatches("\n").length > 4 || text.length > _longCharCount;

  String shortenText(String text) =>
      text.replaceAll("\n", " ").substring(0, (_longCharCount * 0.7).round()) +
      "... ";

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final prop = widget.property;
    return GestureDetector(
      onTap: prop.onTap,
      onLongPress: prop.onLongPress ??
          () {
            Clipboard.setData(ClipboardData(text: prop.value));
            // TODO: Some *better* way to indicate this
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
            // Fold text if it's very long
            child: isLong(prop.value ?? "")
                // TODO: Animate this
                ? RichText(
                    text: TextSpan(
                      style: th.textTheme.bodyText2,
                      children: [
                        TextSpan(
                          text: showLong
                              ? prop.value! + "\n"
                              : shortenText(prop.value!),
                        ),
                        TextSpan(
                          text: showLong ? "Show less" : "Show all",
                          style: th.textTheme.bodyText1
                              ?.copyWith(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => setState(() => showLong = !showLong),
                        )
                      ],
                    ),
                  )
                : Text(prop.value ?? "<unknown>"),
          ),
        ],
      ),
    );
  }
}

/// Universal class to hold "key-value" like properties - like "Name: rule.jpg"
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
