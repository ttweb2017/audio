import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class KaraokeVideoPlayer extends StatefulWidget {
  KaraokeVideoPlayer({Key key, @required this.videoPlayerController}) : super(key: key);
  final VideoPlayerController videoPlayerController;

  @override
  _KaraokeVideoPlayerState createState() => _KaraokeVideoPlayerState(videoPlayerController);
}

class _KaraokeVideoPlayerState extends State<KaraokeVideoPlayer> {
  VideoPlayerController videoPlayerController;

  _KaraokeVideoPlayerState(this.videoPlayerController);

  @override
  void initState() {
  // TODO: Video Player implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Video Player implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: Video Player implement build
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: videoPlayerController.value.isPlaying
              ? Color(0xFF00BFFF)
              : Color(0xFFFF0000)),
        )
      ),
      margin: EdgeInsets.only(top: 65.0),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          ),
          Positioned.fill(
            left: -50.0,
            bottom: -5.0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child:  _playerControllerWidget(),
            ),
          )
        ],
      ),
    );
  }

  Widget _playerControllerWidget(){
    return CupertinoButton(
      child: _playerControlWidgetView(),
      color: Color(0x000000),
      onPressed: (){
        setState(() {
          if(videoPlayerController.value.isPlaying){
            videoPlayerController.pause();
          }else{
            videoPlayerController.play();
          }
        });
      },
    );
  }

  Widget _playerControlWidgetView(){
    return Container(
      height: 50,
      width: 50,
      child: Center(
        child: videoPlayerController != null && videoPlayerController.value.isPlaying
            ? Icon(CupertinoIcons.pause_solid, size: 40.0, color: Color(0xFF00BFFF))
            : Icon(CupertinoIcons.play_arrow_solid, size: 40.0, color: Color(0xFFFF0000)),
      ),
    );
  }

}