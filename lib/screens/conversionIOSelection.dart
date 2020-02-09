import 'package:docit_v1_0_0/screens/ApiEvents/getTypeOfFormats.dart';
import 'package:docit_v1_0_0/screens/uploadScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

String selectedInput;
String selectedOutput;

class ConversionIoSelction extends StatefulWidget {
  final String category;
  ConversionIoSelction(this.category);

  @override
  _ConversionIoSelctionState createState() => _ConversionIoSelctionState();
}

class _ConversionIoSelctionState extends State<ConversionIoSelction> {
  ProgressDialog pr;
  Future<Map<String, List>> checkData;

  refresh() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    checkData = getExtensions();
  }

  Future<Map<String, List>> getExtensions() {
    return getInputOutputFormatOnGroup(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return WillPopScope(
      onWillPop: () {
        selectedInput = null;
        selectedOutput = null;
        Navigator.pop(context);
        return null;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.grey,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xffad5389), Color(0xff3c1053)])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.category.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          selectedInput == null
                              ? "From"
                              : selectedInput.toUpperCase(),
                          style: TextStyle(
                              color: selectedInput == null
                                  ? Colors.grey
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        Text(
                          selectedOutput == null
                              ? "To"
                              : selectedOutput.toUpperCase(),
                          style: TextStyle(
                              color: selectedOutput == null
                                  ? Colors.grey
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 180, 10, 0),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: new BorderRadius.circular(20)),
                    child: FutureBuilder<Map<String, List>>(
                      future: checkData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    borderRadius: new BorderRadius.vertical(
                                        top: Radius.circular(10))),
                                height: 60,
                                child: Center(
                                    child: Text(
                                  "Select Type",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                              SingleChildScrollView(
                                child: Column(children: <Widget>[
                                  ExpansionTileInput(snapshot.data, refresh),
                                  ExpansionTileOutput(snapshot.data, refresh),
                                  selectedInput != null &&
                                          selectedOutput != null &&
                                          selectedOutput != selectedInput
                                      ? Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: FlatButton.icon(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                            ),
                                            color: const Color(0xFF3366FF),
                                            icon: Icon(
                                              Icons.loop,
                                              color: Colors.white,
                                            ),
                                            label: Text('Convert',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UploadScreen(
                                                            selectedOutput,
                                                            selectedInput),
                                                  ));
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            "Please Select input and output Type to proceed",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        )
                                ]),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            height: MediaQuery.of(context).size.height - 400,
                            child: Scaffold(
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
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: FlatButton.icon(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        color: const Color(0xFF3366FF),
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                        ),
                                        label: Text('Refresh',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            pr.show();
                                            checkData = getExtensions();
                                            Future.delayed(Duration(seconds: 3))
                                                .then((value) {
                                              pr.hide();
                                            });
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
                          height: MediaQuery.of(context).size.height - 400,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blueAccent,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class ExpansionTileInput extends StatefulWidget {
  final Function() notifyParent;
  final Map<String, List<String>> io;
  const ExpansionTileInput(this.io, this.notifyParent);

  @override
  _ExpansionTileInputState createState() => _ExpansionTileInputState();
}

class _ExpansionTileInputState extends State<ExpansionTileInput> {
  @override
  Widget build(BuildContext context) {
    List<String> input = widget.io.keys.toList();
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(10),
      child: Theme(
        data: Theme.of(context).brightness == Brightness.light
            ? ThemeData.light()
            : ThemeData.dark(),
        child: ExpansionTile(
            key: GlobalKey(),
            subtitle: Text(
              "Select the input type by clicking ⌄ icon",
              style: TextStyle(color: Colors.grey),
            ),
            title: Text("Input Type"),
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                crossAxisCount: 3,
                padding: const EdgeInsets.all(20.0),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 4),
                children: List.generate(input.length, (index) {
                  return FlatButton(
                    onPressed: () {
                      setState(() {
                        selectedInput = input[index];
                      });
                      widget.notifyParent();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      input[index],
                    )),
                  );
                }),
              )
            ]),
      ),
    );
  }
}

class ExpansionTileOutput extends StatefulWidget {
  final Function() notifyParent;

  final Map<String, List<String>> io;

  ExpansionTileOutput(this.io, this.notifyParent);
  @override
  _ExpansionTileOutputState createState() => _ExpansionTileOutputState();
}

class _ExpansionTileOutputState extends State<ExpansionTileOutput> {
  @override
  Widget build(BuildContext context) {
    List<String> input = widget.io.keys.toList();
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(10),
      child: Theme(
        data: Theme.of(context).brightness == Brightness.light
            ? ThemeData.light()
            : ThemeData.dark(),
        child: ExpansionTile(
            key: GlobalKey(),
            subtitle: Text(
              "Select the output type by clicking ⌄ icon",
              style: TextStyle(color: Colors.grey),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Output Type"),
              ],
            ),
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                crossAxisCount: 3,
                padding: const EdgeInsets.all(20.0),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 4),
                children: List.generate(input.length, (index) {
                  return FlatButton(
                    onPressed: () {
                      setState(() {
                        selectedOutput = input[index];
                      });
                      widget.notifyParent();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      input[index],
                    )),
                  );
                }),
              )
            ]),
      ),
    );
  }
}
