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
        child: GridView.count(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
          children: List.generate(11, (index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            typesOfConvertor[index],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton.icon(
                              onPressed: () {
                                List<String> metadata =
                                    typesOfConvertor[index].split(" ");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConversionIoSelction(
                                              metadata[0].toLowerCase()),
                                    ));
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blue,
                              ),
                              label: Text("Let's Go")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
