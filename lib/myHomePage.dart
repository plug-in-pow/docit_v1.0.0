import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'screens/aboutTab.dart';
import 'screens/homeTab.dart';
import 'screens/settingTab.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSwitched = false;

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
    Brightness val = Theme.of(context).brightness;
    log('data: $val');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 5),
        )),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.settings)),
            Tab(icon: Icon(Icons.assignment))
          ],
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: TabBarView(
        children: <Widget>[HomeTab(), SettingTab(), AboutTab()],
      ),
    );
  }
}
