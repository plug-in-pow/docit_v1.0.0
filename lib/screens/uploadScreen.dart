import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<String> _filenames = [];
  List<String> _filesize = [];
  List<String> docPaths = [];

  void filepick() async {
    String sizeOfFile;
    try {
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
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Unexpected Error !'),
      ));
    }

    if (!mounted) {
      return;
    }
  }

  void removeFiles(int index) {
    return setState(() {
      _filenames.removeAt(index);
      _filesize.removeAt(index);
      docPaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Upload '),
      ),
      body: ListView.builder(
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
                    Icons.picture_as_pdf,
                    color: Colors.white,
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
                  title: Text(
                    'File Name : ${_filenames[index]}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Size : ${_filesize[index]}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
