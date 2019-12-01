import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/karaoke_main_screen.dart';
import 'package:vplayer/karaoke_screen.dart';
import 'package:vplayer/model/app_state_model.dart';

//void main() => runApp(MyApp());

void main() {
  return runApp(
      ChangeNotifierProvider<AppStateModel>(
        builder: (context) => AppStateModel()..loadData(),
        child: KaraokeApp(),
      )
  );
}

class KaraokeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoApp(
      title: Karaoke.APP_TITLE,
      home: KaraokePage(
          title: Karaoke.MAIN_PAGE
      ),
    );
  }
}