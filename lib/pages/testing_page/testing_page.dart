import 'package:dotmeme/analyze/ocr/ocr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  String _outText = "";
  int _time = 0;
  String _outTextFast = "";
  int _timeFast = 0;
  String _outTextBest = "";
  int _timeBest = 0;

  void scan(String file) async {
    _outText = '';
    _outTextFast = '';
    _outTextBest = '';
    var watch = Stopwatch();
    watch.start();
    _outText = await Ocr.getText(imagePath: file, language: 'eng');
    _time = watch.elapsedMilliseconds;
    print('eng finished! Time: $_time ms');
    setState(() {});

    watch.reset();
    _outTextFast = await Ocr.getText(imagePath: file, language: 'eng_fast');
    _timeFast = watch.elapsedMilliseconds;
    print('eng_fast finished! Time: $_timeFast ms');
    setState(() {});

    watch.reset();
    _outTextBest = await Ocr.getText(imagePath: file, language: 'eng_best');
    _timeBest = watch.elapsedMilliseconds;
    print('eng_best finished! Time: $_timeBest ms');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testing page')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              RaisedButton(
                child: Text('Pick image'),
                onPressed: () {
                  FilePicker.getFilePath(type: FileType.image).then((path) {
                    scan(path);
                  });
                },
              ),
              SizedBox(height: 30),
              Text('Eng',
                  style:
                  TextStyle(fontSize: 30, backgroundColor: Colors.orange)),
              Text(_outText),
              Text('Eng_fast',
                  style:
                  TextStyle(fontSize: 30, backgroundColor: Colors.orange)),
              Text(_outTextFast),
              Text('Eng_best',
                  style:
                  TextStyle(fontSize: 30, backgroundColor: Colors.orange)),
              Text(_outTextBest),
            ],
          ),
        ),
      ),
    );
  }
}
