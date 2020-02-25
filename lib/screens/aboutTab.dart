import 'package:docit_v1_0_0/screens/uploadScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutTab extends StatefulWidget {
  @override
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  Future<List<String>> listOfFavConversion;
  @override
  void initState() {
    super.initState();
    listOfFavConversion = _getList();
  }

  Future<List<String>> _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> resultList = prefs.getStringList("FavList");
    if (resultList.isEmpty) {
      return null;
    }
    return resultList;
  }

  _removeTile(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList("FavList");
    temp.removeAt(index);
    prefs.clear();
    await prefs.setStringList("FavList", temp);
    setState(() {
      listOfFavConversion = _getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: listOfFavConversion,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != []) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 370),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Theme(
                          data: ThemeData.dark(),
                          child: Card(
                            margin: EdgeInsets.all(10),
                            color: Color(0xff574b90),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _removeTile(index);
                                },
                              ),
                              title: Text(snapshot.data[index]),
                              subtitle:
                                  Text('Convert from ${snapshot.data[index]}'),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () async {
                                  List<String> tempList =
                                      snapshot.data[index].split(" ");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadScreen(
                                            tempList[2], tempList[0]),
                                      )).then((value) {
                                    setState(() {
                                      listOfFavConversion = _getList();
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        } else if (snapshot.data == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              Text(
                "List is empty",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blueAccent,
            strokeWidth: 2,
          ),
        );
      },
    );
  }
}
