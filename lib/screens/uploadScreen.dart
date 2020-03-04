import 'dart:io';
import 'package:docit_v1_0_0/screens/downloadPage.dart';
import 'package:filesize/filesize.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadScreen extends StatefulWidget {
  final String inputType;
  final String outputType;
  UploadScreen(this.outputType, this.inputType);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  ProgressDialog pr;
  List<String> _filenames = [];
  List<String> _filesize = [];
  List<String> docPaths = [];
  bool isPressed = false;

  Future<bool> _saveList() async {
    List<String> list = [];
    list.add(widget.inputType + " to " + widget.outputType);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList("FavList");

    if (temp != null) {
      if (!temp.contains(list[0])) {
        list.addAll(temp);
        return await prefs.setStringList("FavList", list);
      }
    }

    return await prefs.setStringList("FavList", list);
  }

  Future<bool> _removeFromList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList("FavList");
    temp.remove(widget.inputType + " to " + widget.outputType);
    prefs.clear();
    return await prefs.setStringList("FavList", temp);
  }

  void _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> resultList = prefs.getStringList("FavList");
    if (resultList != null) {
      if (resultList.contains(widget.inputType + " to " + widget.outputType)) {
        setState(() {
          isPressed = true;
        });
      }
    }
  }

  void filepick() async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    pr.style(
        message: "Loading Files",
        progressWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ));
    int flag = 0;
    String sizeOfFile;
    try {
      pr.show();
      Map<String, String> temp = await FilePicker.getMultiFilePath();

      setState(() {
        for (var fileNamesPresent in temp.keys) {
          String ext = p.extension(temp[fileNamesPresent]);
          if (ext == "." + widget.inputType && docPaths.length < 5) {
            docPaths.add(temp[fileNamesPresent]);
            _filenames.add(fileNamesPresent);
            int size = File(temp[fileNamesPresent]).lengthSync();
            sizeOfFile = filesize(size);
            _filesize.add(sizeOfFile);
          } else {
            flag = 1;
          }
        }
      });

      if (flag == 1) {
        _wrongExtensionAlert(context).then((value) {
          Future.delayed(Duration(seconds: 1)).then((value) {
            pr.hide();
          });
        });
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          pr.hide();
        });
      }
    } catch (e) {
      Future.delayed(Duration(seconds: 0)).then((value) {
        pr.hide();
      });
    }

    if (!mounted) {
      return;
    }
  }

  Future<void> _noFileAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('No Files as been added'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _wrongExtensionAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              '● Maximum 5 files can be selected at once.\n● Some files is of wrong extension please add file with .${widget.inputType} extension only.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showToastRemoveFav(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Removed'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Successfully removed from favourite'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showToastAddFav(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Added'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Successfully added to favourite'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeFiles(int index) {
    return setState(() {
      _filenames.removeAt(index);
      _filesize.removeAt(index);
      docPaths.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return null;
      },
      child: Stack(children: <Widget>[
        Scaffold(
          body: Builder(
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xffad5389), Color(0xff3c1053)])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      widget.inputType + "  ➟  " + widget.outputType,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 38),
                      child: SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent, // button color
                            child: InkWell(
                              splashColor: Colors.pinkAccent, // splash color
                              onTap: () async {
                                if (isPressed == false) {
                                  if (await _saveList()) {
                                    setState(() {
                                      isPressed = !isPressed;
                                    });
                                    this._showToastAddFav(context);
                                  }
                                } else if (isPressed == true) {
                                  if (await _removeFromList()) {
                                    setState(() {
                                      isPressed = !isPressed;
                                    });
                                    this._showToastRemoveFav(context);
                                  }
                                }
                                if (!isPressed) {
                                  _removeFromList();
                                }
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    isPressed
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isPressed
                                        ? Colors.redAccent
                                        : Colors.white,
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    heroTag: "btn-1",
                    icon: Icon(Icons.cached),
                    onPressed: () {
                      if (docPaths.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DownloadPage(
                                  widget.inputType,
                                  widget.outputType,
                                  docPaths),
                            ));
                      } else {
                        _noFileAlert(context);
                      }
                    },
                    label: Text('Convert'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    heroTag: "btn-2",
                    icon: Icon(Icons.add),
                    onPressed: () {
                      filepick();
                    },
                    label: Text('Add File'),
                  ),
                )
              ],
            ),
            body: _filenames.length == 0
                ? DisplayWhenEmpty(widget.inputType)
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 120),
                    itemCount: _filenames.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: new Color(0xff2a5298),
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.insert_drive_file,
                                color: Colors.white,
                                size: 45,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  removeFiles(index);
                                },
                              ),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'File Name : ${_filenames[index]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Size : ${_filesize[index]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ]),
    );
  }
}

class DisplayWhenEmpty extends StatelessWidget {
  final String inputType;
  const DisplayWhenEmpty(
    this.inputType, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_circle_outline,
            color: Colors.grey,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Click on "Add File" to add file with extension .$inputType',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
