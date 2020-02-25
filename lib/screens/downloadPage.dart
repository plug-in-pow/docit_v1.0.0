import 'package:dio/dio.dart';
import 'package:docit_v1_0_0/screens/ApiEvents/uploadAndDownload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

class DownloadPage extends StatefulWidget {
  final String inputType;
  final String outputType;
  final List<String> paths;
  DownloadPage(this.inputType, this.outputType, this.paths);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  Future<List<String>> downloadPaths;
  Dio dio = new Dio();

  @override
  void initState() {
    super.initState();
    downloadPaths = createUploadJob(
        widget.inputType, widget.outputType, widget.paths, context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "Download",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: FutureBuilder<List<String>>(
                future: downloadPaths,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 20,
                            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            color: Color(0xff5959ab),
                            child: ListTile(
                              leading: Icon(
                                Icons.insert_drive_file,
                                size: 40,
                                color: Colors.white,
                              ),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  p
                                          .basename(widget.paths[index])
                                          .split(".")[0] +
                                      '.' +
                                      widget.outputType,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              subtitle: Align(
                                alignment: Alignment.centerLeft,
                                child: FlatButton.icon(
                                    onPressed: () async {
                                      String url = snapshot.data[index];
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    icon: Icon(
                                      Icons.file_download,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Download",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          snapshot.error,
                          softWrap: true,
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.blueAccent,
                          strokeWidth: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text("Converting Please wait..."),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
