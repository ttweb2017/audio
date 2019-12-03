import 'package:flutter/cupertino.dart';
import 'package:vplayer/karaoke_screen.dart';
import 'package:vplayer/model/song.dart';

import 'styles.dart';

class SongRowItem extends StatelessWidget {
  const SongRowItem({
    this.index,
    this.song,
    this.lastItem
  });

  final Song song;
  final int index;
  final bool lastItem;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) => KaraokeScreen(
                    song: song
                ),
              ),
            );
          },
          child: Container(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    song.avatar,
                    package: song.avatarPackage,
                    fit: BoxFit.cover,
                    width: 56,
                    height: 56,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          song.name,
                          style: Styles.singerRowItemName,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8)),
                        Text(
                          '${song.singer.fullName}',
                          style: Styles.singerRowItemPrice,
                        )
                      ],
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    //final model = Provider.of<AppStateModel>(context);
                    //model.playSong(song.id);

                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<bool>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => KaraokeScreen(
                            song: song
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.play_arrow,
                    semanticLabel: 'Play',
                  ),
                ),
              ],
            ),
          ),
        ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 100,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: Styles.singerRowDivider,
          ),
        ),
      ],
    );
  }
}