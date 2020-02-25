import 'package:docit_v1_0_0/screens/conversionIOSelection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<String> typesOfConvertor = [
    "Document Converter",
    "Image Converter",
    "Presentation Converter",
    "Spreadsheet Converter",
    "Audio Converter",
    "Video Converter",
    "Ebook Converter",
    "Font Converter",
    "Archive Converter",
    "CAD Converter",
    "Vector Converter"
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 11,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 370),
              columnCount: 1,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Color(0xFF2e5090),
                    child: ListTile(
                        onTap: () {
                          List<String> metadata =
                              typesOfConvertor[index].split(" ");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversionIoSelction(
                                    metadata[0].toLowerCase()),
                              ));
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.autorenew, color: Colors.white),
                        ),
                        title: Text(
                          typesOfConvertor[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
