import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:vplayer/Karaoke.dart';

class KaraokeVideoPlayer extends StatefulWidget {
  @override
  _KaraokeVideoPlayerState createState() => _KaraokeVideoPlayerState();
}

class _KaraokeVideoPlayerState extends State<KaraokeVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: Video Player implement initState
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
      child: Stack(
        children: <Widget>[
          _playerControllerWidget(),
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot){
              return snapshot.connectionState == ConnectionState.done
                  ? AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio, child: VideoPlayer(_videoPlayerController))
                  : Center(child: CupertinoActivityIndicator());
            }
          )
        ],
      ),
    );
  }

  Widget _playerControllerWidget(){
    return CupertinoButton(
      child: _videoPlayerController.value.isPlaying ? Icon(CupertinoIcons.pause) : Icon(CupertinoIcons.pause),
      onPressed: (){
        _videoPlayerController.value.isPlaying ? _videoPlayerController.play() : _videoPlayerController.pause();
      },
    );
  }

}