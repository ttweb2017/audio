import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/song_tab.dart';

class KaraokePage extends StatefulWidget {
  KaraokePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KaraokePageState createState() => _KaraokePageState();
}

class _KaraokePageState extends State<KaraokePage> {
  Map<PermissionGroup, PermissionStatus> permissions;

  @override
  void initState(){
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_note),
            title: Text(Karaoke.APP_TITLE),
          ),
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
                  child: SongListTab()
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                  child: SongListTab()
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }

  void getPermission() async {
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.photos,
      PermissionGroup.microphone,
    ]);
  }
}