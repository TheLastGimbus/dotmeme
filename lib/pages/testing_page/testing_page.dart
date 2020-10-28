import 'package:dotmeme/analyze/ocr/ocr.dart';
import 'package:dotmeme/background/periodic_cv_scan.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  String _outTextFast = "";
  int _timeFast = 0;

  void scan(String file) async {
    _outTextFast = '';
    var watch = Stopwatch();
    watch.start();
    _outTextFast = await Ocr.getText(imagePath: file, language: 'eng_fast');
    _timeFast = watch.elapsedMilliseconds;
    print('eng_fast finished! Time: $_timeFast ms');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var memesProvider = Provider.of<MemesProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Testing page')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              RaisedButton(
                child: Text('Test sync'),
                onPressed: () async {
                  await memesProvider.syncFolders();
                  await memesProvider.syncMemes();
                },
              ),
              RaisedButton(
                child: Text('Test getAllMemes'),
                onPressed: () {
                  memesProvider.getAllMemes;
                },
              ),
              RaisedButton(
                child: Text('Pick image'),
                onPressed: () {
                  FilePicker.getFilePath(type: FileType.image).then((path) {
                    scan(path);
                  });
                },
              ),
              RaisedButton(
                child: Text('Test background scan (not really in background)'),
                onPressed: () {
                  PeriodicCvScan.ocrScan(taskName: "TEST SCAN");
                },
              ),
              RaisedButton(
                child: Text('Schedule one-time scan task'),
                onPressed: () => Workmanager.registerOneOffTask(
                  "one-time-scan-test",
                  PeriodicCvScan.TASK_NAME_OCR,
                  existingWorkPolicy: ExistingWorkPolicy.replace,
                ),
                onLongPress: () => Workmanager.registerOneOffTask(
                  "one-time-scan-test",
                  PeriodicCvScan.TASK_NAME_OCR,
                  existingWorkPolicy: ExistingWorkPolicy.replace,
                  initialDelay: Duration(seconds: 10),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Eng_fast',
                style: TextStyle(fontSize: 30, backgroundColor: Colors.orange),
              ),
              SelectableText(_outTextFast),
            ],
          ),
        ),
      ),
    );
  }
}
