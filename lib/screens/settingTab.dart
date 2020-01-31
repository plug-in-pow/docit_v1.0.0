import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  void lightTheme() {
    DynamicTheme.of(context).setBrightness(Brightness.light);
  }

  void darkTheme() {
    DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text('Select Theme'),
          children: <Widget>[
            RadioListTile<Brightness>(
              activeColor: Colors.deepPurpleAccent,
              value: Brightness.light,
              groupValue: Theme.of(context).brightness,
              onChanged: (Brightness value) {
                DynamicTheme.of(context).setBrightness(value);
              },
              title: const Text('Light mode 🌞'),
            ),
            RadioListTile<Brightness>(
              activeColor: Colors.deepPurpleAccent,
              value: Brightness.dark,
              groupValue: Theme.of(context).brightness,
              onChanged: (Brightness value) {
                DynamicTheme.of(context).setBrightness(value);
              },
              title: const Text('Dark Mode 🌙'),
            )
          ],
        ),
        SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text('About Us'),
          contentPadding: EdgeInsets.all(20),
          children: [
            Center(
              child: Text(
                "Developed By",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Center(
              child: Text(
                "MAYANK",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
              ),
            ),
            Center(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: const Color(0xFF3366FF),
                    icon: Icon(Icons.link),
                    label: Text("Github"),
                    onPressed: _launchURL,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  void _launchURL() async {
    const url = 'https://github.com/plug-in-pow/docit';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
