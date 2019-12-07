import 'package:flutter/cupertino.dart';
import 'package:vplayer/model/app_state_model.dart';
import 'package:vplayer/model/singer.dart';
import 'package:vplayer/song_row_item.dart';
import 'package:vplayer/styles.dart';
import 'package:provider/provider.dart';

class SingerSongsScreen extends StatefulWidget {
  SingerSongsScreen({Key key, this.singer}) : super(key: key);

  final Singer singer;

  @override
  _SingerSongsScreenState createState() {
    return _SingerSongsScreenState(singer);
  }
}

class _SingerSongsScreenState extends State<SingerSongsScreen> {
  Singer singer;

  _SingerSongsScreenState(this.singer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final results = model.searchSongBySinger(singer);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
        middle: Text(singer.name),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Styles.scaffoldBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => SongRowItem(
                    index: index,
                    song: results[index],
                    lastItem: index == results.length - 1
                  ),
                  itemCount: results.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}