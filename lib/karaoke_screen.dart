import 'package:flutter/cupertino.dart';
import 'package:vplayer/camera_recorder.dart';
import 'package:vplayer/model/song.dart';
import 'package:vplayer/video_payer.dart';

class KaraokeScreen extends StatefulWidget {
  KaraokeScreen({Key key, @required this.song}) : super(key: key);
  final Song song;

  @override
  _KaraokeScreenState createState() => _KaraokeScreenState(song);
}

class _KaraokeScreenState extends State<KaraokeScreen> {
  Song song;
  _KaraokeScreenState(this.song);

  @override
  void initState() {
    // TODO: Karaoke screen implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Karaoke screen implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Karaoke screen implement build
    return CupertinoPageScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFF)
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: KaraokeVideoPlayer(song: song)
              ),
              Expanded(
                flex: 3,
                child: KaraokeCameraRecorder(),
              )
            ],
          )
        ],
      ),
    );
  }
}