import 'package:flutter/cupertino.dart';
import 'package:vplayer/Karaoke.dart';

class KaraokePage extends StatefulWidget {
  KaraokePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KaraokePageState createState() => _KaraokePageState();
}

class _KaraokePageState extends State<KaraokePage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_note),
            title: Text(Karaoke.APP_TITLE),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                  child: KaraokePage(title: Karaoke.MAIN_PAGE)
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}