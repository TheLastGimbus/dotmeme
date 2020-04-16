import 'package:flutter/material.dart';

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
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Pick image'),
              onPressed: () {},
            ),
            SizedBox(height: 30),
            Text(_outText),
          ],
        ),
      ),
    );
  }
}
