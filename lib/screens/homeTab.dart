// import 'dart:collection';
// import 'package:docit_v1_0_0/screens/uploadScreen.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
// import '../permission.dart';

Map<String, List> inputOutputPair = {};
List<String> _coresspondingOutputFormat = [];
var selectedOutItem;
var selectedInItem;

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ProgressDialog pr;
  Map<String, List> temp = {};
  Future<Map<String, List>> checkData;

  @override
  initState() {
    super.initState();
    // data = fetchData();
    checkData = getExtensions();
  }

  Future<Map<String, List>> getExtensions() async {
    try {
      http.Response response = await http.get(
          Uri.encodeFull("https://api.cloudconvert.com/v2/convert/formats"),
          headers: {"Accept": "application/json"});

      Map<String, dynamic> data = json.decode(response.body);
      temp = {};

      for (var i = 0; i <= 1876; i++) {
        temp[data["data"][i]["input_format"]] = [];
      }
      for (var i = 0; i <= 1876; i++) {
        temp[data["data"][i]["input_format"]]
            .add(data["data"][i]["output_format"]);
      }
      return temp;
    } on SocketException {
      return Future.error("Network Error please connect to internet",
          StackTrace.fromString("Network Failure"));
    } catch (e) {
      return Future.error(
          'Something went wrong please reinstall or restart the app');
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, List>>(
          future: checkData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              inputOutputPair = snapshot.data;
              return ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  ConversionCard(),
                  HomePageImage(),
                  BottomText()
                ],
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  label: Text('Reload'),
                  onPressed: () {
                    setState(() {
                      pr.show();
                      checkData = getExtensions();
                      Future.delayed(Duration(seconds: 3)).then((value) {
                        pr.hide();
                      });
                    });
                  },
                  icon: Icon(Icons.update),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            // By default
            return CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
              strokeWidth: 2,
            );
          },
        ),
      ),
    );
  }
}

class BottomText extends StatelessWidget {
  const BottomText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Make document conversion easier !!!',
      style: TextStyle(color: Colors.grey),
    ));
  }
}

class HomePageImage extends StatelessWidget {
  const HomePageImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Image.asset(
        'assets/images/documents.png',
        height: 240,
        width: 250,
      ),
    );
  }
}

class ConversionCard extends StatelessWidget {
  const ConversionCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF3366FF),
                const Color(0xFF00CCFF),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: <Widget>[
            CardHeaderText(),
            CenterRowWidget(),
            CardBottomButton()
          ],
        ),
      ),
    );
  }
}

class CardBottomButton extends StatelessWidget {
  const CardBottomButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        color: const Color(0xFF3366FF),
        icon: Icon(
          Icons.loop,
          color: Colors.white,
        ),
        label: Text('Convert', style: TextStyle(color: Colors.white)),
        onPressed: () {},
      ),
    );
  }
}

class CenterRowWidget extends StatefulWidget {
  const CenterRowWidget({
    Key key,
  }) : super(key: key);

  @override
  _CenterRowWidgetState createState() => _CenterRowWidgetState();
}

class _CenterRowWidgetState extends State<CenterRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('From :', style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          hint: Text('Input'),
          value: selectedInItem,
          onChanged: (String value) {
            setState(() {
              selectedInItem = value;
              selectedOutItem = null;
              _coresspondingOutputFormat = [];
              _coresspondingOutputFormat =
                  inputOutputPair[value].cast<String>();
            });
          },
          items: inputOutputPair.keys.map((String label) {
            return new DropdownMenuItem<String>(
              value: label,
              child: new Text(label),
            );
          }).toList(),
        ),
        Text('To :', style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          value: selectedOutItem,
          hint: Text('Output'),
          onChanged: (String value) {
            setState(() {
              selectedOutItem = value;
            });
          },
          items: _coresspondingOutputFormat.map((String label) {
            return new DropdownMenuItem<String>(
              value: label,
              child: new Text(label),
            );
          }).toList(),
        )
      ],
    );
  }
}

class CardHeaderText extends StatelessWidget {
  const CardHeaderText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Convert",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
