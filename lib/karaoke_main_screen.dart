import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/search_tab.dart';
import 'package:vplayer/singer_list_tab.dart';
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
            icon: Icon(CupertinoIcons.home),
            title: Text(Karaoke.NAVIGATION_POPULAR),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_note),
            title: Text(Karaoke.NAVIGATION_SONG),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
            title: Text(Karaoke.NAVIGATION_SINGER),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text(Karaoke.NAVIGATION_SEARCH),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                  child: SongListTab(isPopular: true)
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                  child: SongListTab(isPopular: false)
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SingerListTab(),
              );
            });
            break;
          case 3:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SearchTab(),
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