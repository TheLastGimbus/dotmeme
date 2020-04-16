import 'package:dotmeme/analyze/ocr/ocr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  String _outText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testing page')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text('Pick image'),
                onPressed: () async {
                  var file = await FilePicker.getFilePath(type: FileType.image);
                  _outText = await Ocr.getText(imagePath: file);
                  setState(() {});
                },
              ),
              SizedBox(height: 30),
              Text(_outText),
            ],
          ),
        ),
      ),
    );
  }
}
