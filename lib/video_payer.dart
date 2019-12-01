import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/model/song.dart';

class KaraokeVideoPlayer extends StatefulWidget {
  KaraokeVideoPlayer({Key key, @required this.song}) : super(key: key);
  final Song song;

  @override
  _KaraokeVideoPlayerState createState() => _KaraokeVideoPlayerState(song);
}

class _KaraokeVideoPlayerState extends State<KaraokeVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  Song song;

  _KaraokeVideoPlayerState(this.song);

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      Karaoke.FULL_VIDEO_URL
    );

    // initialize the controller and store the future for later use
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: Video Player implement dispose
    _videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: Video Player implement build
    return Container(
      //height: 300.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _videoPlayerController.value.isPlaying
              ? Color(0xFF00BFFF)
              : Color(0xFFFF0000)),
        )
      ),
      margin: EdgeInsets.only(top: 65.0),
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                _videoPlayerController.seekTo(Duration.zero);
                return AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                );
              }else{
                return Center(child: CupertinoActivityIndicator());
              }
            }
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
          if(_videoPlayerController.value.isPlaying){
            _videoPlayerController.pause();
          }else{
            _videoPlayerController.play();
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
        child: _videoPlayerController != null && _videoPlayerController.value.isPlaying
            ? Icon(CupertinoIcons.pause_solid, size: 40.0, color: Color(0xFF00BFFF))
            : Icon(CupertinoIcons.play_arrow_solid, size: 40.0, color: Color(0xFFFF0000)),
      ),
    );
  }

  /*Widget _playerControlWidgetView(){
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
              color: _videoPlayerController != null && _videoPlayerController.value.isPlaying
                  ? Color(0xFF00BFFF)
                  : Color(0xFFFFFFFF)
          ),
          color: _videoPlayerController != null && _videoPlayerController.value.isPlaying
              ? Color(0xFFFF0000)
              : Color(0xFF00BFFF)
      ),
      child: Center(
        child: _videoPlayerController != null && _videoPlayerController.value.isPlaying
            ? Icon(CupertinoIcons.pause, size: 30.0, color: Color(0xFF00BFFF))
            : Icon(CupertinoIcons.play_arrow, size: 30.0, color: Color(0xFFFFFFFF)),
      ),
    );
  }*/

}