import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/karaoke_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoApp(
      title: Karaoke.APP_TITLE,
      home: KaraokeScreen(
          title: Karaoke.MAIN_PAGE
      ),
    );
  }
}