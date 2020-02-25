import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dart files import
import 'myHomePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Function duringSplash = () {
    print('Dummy Print Statement ....');
    int a = 123 + 23;

    if (a > 100)
      return 1;
    else
      return 2;
  };

  Map<int, Widget> op = {1: MyApp()};

  await DotEnv().load('.env');
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: CustomSplash(
            logoSize: 200,
            backGroundColor: new Color(0xff1874D2),
            animationEffect: 'fade-in',
            imagePath: 'assets/images/giphy.gif',
            home: MyApp(),
            customFunction: duringSplash,
            duration: 50,
            type: CustomSplashType.StaticDuration,
            outputAndHome: op,
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              fontFamily: 'OpenSans',
              primarySwatch: Colors.deepPurple,
              tabBarTheme: TabBarTheme(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
              ),
              brightness: brightness,
              accentColor: Colors.white,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: theme,
            home: DefaultTabController(
              length: 3,
              child: MyHomePage(title: 'DocIT'),
            ),
          );
        });
  }
}
