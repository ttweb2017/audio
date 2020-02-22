import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/song_row_item.dart';

import 'model/app_state_model.dart';

class SongListTab extends StatelessWidget {
  SongListTab({Key key, @required this.isPopular}) : super(key: key);

  final bool isPopular;

  @override
  Widget build(BuildContext context) {

    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        if(isPopular){
          model.checkPopularSongs();
        }else{
          model.checkSongs();
        }

        final songs = isPopular ? model.getPopularSongs() : model.getSongs();

        return CustomScrollView(
          semanticChildCount: songs.length,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(Karaoke.SONG_SCREEN_TITLE),
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index < songs.length) {
                      return SongRowItem(
                          index: index,
                          song: songs[index],
                          lastItem: index == songs.length - 1
                      );
                    }
                    return null;
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}