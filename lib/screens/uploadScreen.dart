import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class UploadScreen extends StatefulWidget {
  final String inputType;
  final String outputType;
  UploadScreen(this.outputType, this.inputType);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjJlOTMwZTlmZDVhMjBlMDU1OTIyYmY5NWY1NmU2M2ZiMjQ3NjllYmE1MzNmNDRhZjJhNjdkY2VjOTNkYWQ4Yzk3ZmE5MjM5YWYxZThiYmNiIn0.eyJhdWQiOiIxIiwianRpIjoiMmU5MzBlOWZkNWEyMGUwNTU5MjJiZjk1ZjU2ZTYzZmIyNDc2OWViYTUzM2Y0NGFmMmE2N2RjZWM5M2RhZDhjOTdmYTkyMzlhZjFlOGJiY2IiLCJpYXQiOjE1ODA2NDQ1MjAsIm5iZiI6MTU4MDY0NDUyMCwiZXhwIjo0NzM2MzE4MTIwLCJzdWIiOiI0MDA1MTIxOCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.ffHZIsdQrovkG2DG0enO5WAyoD38VRIs3W8g09xHnzzELtH15rW1rcp0hlo9s0G1e4HY-evRlRuQIs4XdELnRcdJlr0yxnXxMPhVk40b-rn5NQuuNvZcLPBoYe0cDjyXYQRkXO2vodL2CFDt_9hJyy7A3cuX55yEysIxg15uvWFxmiPGIX5zds_bWieq4b14s9CUyGm25v9Wq9c9zq41-P1TBsNNL8dfGHNjZDNgqBYUjIcx_E6KdjPOxUIRGK10eNrV-KOtOhYvyc4EFvsc2mmucYqUoBq0qK25I4wIgPMtbJlSknzEtHHEEUZoimoqL5BMncXHYuxpx3UJ6JjRrLqvaVBwMf0ZqBNX7iRWza4gR3rz8XCe34SAT_Yi_7wch46_la_Ze8bShcxXQ-lm88AbxqRTyyBU1DXQ4XQMMHzDXRP4Q2Rpa--0Uc7H4z896lrNH7CBpZYTQMf1xXG_pblWmsNe7ZZ7lftUJ0JkCMP7_deQNbW4nGH1JizajWkfF9veA2XLdypoo6l64PQYHHSpbb4tXUFGo2oFR2Abe_XcvvMWt0IhjouQExe2cPdA_TLd64AXvzuN2DY3GGuQrtxqe0WpDAtBNxlfxk5_wxK9PWjC4dwxkSaZh-rLot2fBIGMrvL6SZFpQS2N1EJaXpEY6LLO_eVg62yZA8fRWUk';
  List<String> _filenames = [];
  List<String> _filesize = [];
  List<String> docPaths = [];

  createImport() async {
    http.Response response = await http.post(
        'https://api.sandbox.cloudconvert.com/v2/import/upload',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json'
        });
    Map<String, dynamic> para = json.decode(response.body);
    uploadFile(para);
  }

  uploadFile(Map<String, dynamic> para) async {
    Map<String, dynamic> formdata = para["data"]["result"]["form"];
    Map<String, dynamic> body = {
      'expires': '${formdata["parameters"]["expires"]}',
      'max_file_count': '${formdata["parameters"]["max_file_count"]}',
      'max_file_size': '${formdata["parameters"]["max_file_size"]}',
      'signature': '${formdata["parameters"]["signature"]}',
      'file': await MultipartFile.fromFile(docPaths[0]),
    };

    var dio = Dio();
    try {
      FormData formData1 = new FormData.fromMap(body);
      var response = await dio.post(
        para["data"]["result"]["form"]["url"],
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'multipart/form-data'
        }),
        data: formData1,
      );
      return response.data;
    } catch (e) {
      print(e);
    }

    // print(para["data"]["result"]["form"]["url"]);
    // var postUri = Uri.parse("${para["data"]["result"]["form"]["url"]}");
    // var request = new http.MultipartRequest("POST", postUri);
    // request.headers['Authorization'] = 'Bearer $token';
    // request.headers['Content-type'] = 'multipart/form-data';
    // request.fields['expires'] = '${formdata["parameters"]["expires"]}';
    // request.fields['max_file_count'] =
    //     '${formdata["parameters"]["max_file_count"]}';
    // request.fields['max_file_size'] =
    //     '${formdata["parameters"]["max_file_size"]}';
    // request.fields['signature'] = '${formdata["parameters"]["signature"]}';
    // request.files.add(new http.MultipartFile.fromBytes(
    //     'file', await File(docPaths[0]).readAsBytes()));
    // request.send().then((response) {
    //   if (response.statusCode == 200)
    //     print("Uploaded!");
    //   else {
    //     print(response.statusCode);
    //   }
    // });
  }

  void filepick() async {
    int flag = 0;
    String sizeOfFile;
    try {
      print(widget.inputType);
      Map<String, String> temp = await FilePicker.getMultiFilePath();

      setState(() {
        for (var fileNamesPresent in temp.keys) {
          docPaths.add(temp[fileNamesPresent]);
          _filenames.add(fileNamesPresent);
          int size = File(temp[fileNamesPresent]).lengthSync();
          double fileSizeInMB = size / (1024);
          if (fileSizeInMB < 1) {
            double fileSizeInKB = fileSizeInMB / (1024);
            sizeOfFile = fileSizeInKB.toStringAsFixed(2) + "KB";
          } else {
            sizeOfFile = fileSizeInMB.toStringAsFixed(2) + "MB";
          }
          _filesize.add(sizeOfFile);
        }
      });
      List<int> indexList = [];
      print("path :${docPaths.length}");
      for (int i = 0; i < docPaths.length; i++) {
        String ext = p.extension(docPaths[i]);
        if (ext != '.${widget.inputType}') {
          indexList.add(i);
          flag = 1;
        }
      }

      print(indexList);

      for (var i = 0; i < indexList.length; i++) {
        _filenames.removeAt(indexList[i]);
        _filesize.removeAt(indexList[i]);
        docPaths.removeAt(indexList[i]);
      }

      if (flag == 1) {
        _wrongExtensionAlert(context);
      }
    } catch (e) {}

    if (!mounted) {
      return;
    }
  }

  Future<void> _wrongExtensionAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Some files is of wrong extension please add file with .${widget.inputType} extension'),
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

  void removeFiles(int index) {
    return setState(() {
      _filenames.removeAt(index);
      _filesize.removeAt(index);
      docPaths.removeAt(index);
    });
  }

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Convert",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44),
                child: IconButton(
                  icon: Icon(
                    isPressed ? Icons.favorite : Icons.favorite_border,
                    color: isPressed ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () => _handleOnPressed(),
                ),
              )
            ],
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
                    createImport();
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
          // appBar: AppBar(
          //   title:
          //       Text(' Upload (${widget.inputType} ➡️ ${widget.outputType})'),
          //   actions: <Widget>[
          //     IconButton(
          //       icon: Icon(
          //         isPressed ? Icons.favorite : Icons.favorite_border,
          //         color: isPressed ? Colors.redAccent : Colors.white,
          //       ),
          //       onPressed: () => _handleOnPressed(),
          //     )
          //   ],
          // ),
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
    ]);
  }

  void _handleOnPressed() {
    setState(() {
      isPressed = !isPressed;
    });
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
