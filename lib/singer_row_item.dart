import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:vplayer/singer_songs.dart';
import 'model/singer.dart';
import 'styles.dart';

class SingerRowItem extends StatelessWidget {
  const SingerRowItem({
    this.index,
    this.singer,
    this.lastItem,
    this.cameras
  });

  final List<CameraDescription> cameras;
  final Singer singer;
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
              builder: (BuildContext context) => SingerSongsScreen(
                  singer: singer
              ),
            ),
          );
        },
        child: Container(
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  singer.avatarUrl,
                  //package: singer.assetPackage,
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
                        singer.name,
                        style: Styles.singerRowItemName,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        '${singer.category}',
                        style: Styles.singerRowItemPrice,
                      )
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => SingerSongsScreen(
                          singer: singer
                      ),
                    ),
                  );
                },
                child: const Icon(
                  CupertinoIcons.forward,
                  semanticLabel: 'Songs',
                ),
              ),
            ],
          ),
        ),
      )
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