import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/camera_recorder.dart';
import 'package:vplayer/model/song.dart';
import 'package:vplayer/splash_screen.dart';
import 'package:vplayer/video_payer.dart';

class KaraokeScreen extends StatefulWidget {
  KaraokeScreen({Key key, @required this.song}) : super(key: key);
  final Song song;

  @override
  _KaraokeScreenState createState() => _KaraokeScreenState(song);
}

class _KaraokeScreenState extends State<KaraokeScreen> {
  VideoPlayerController _videoPlayerController;
  List<CameraDescription> cameras;
  Future<void> _initializeVideoPlayerFuture;

  Song song;
  _KaraokeScreenState(this.song);

  @override
  void initState() {
    // TODO: Karaoke screen implement initState
    _videoPlayerController = VideoPlayerController.network(
        song.fullVideoUrl
    );

    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    _fetchCameras();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: Karaoke screen implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return _karaokeScreenWidget();
        }else{
          return SplashScreen(bottomText: Karaoke.SPLASH_SCREEN_DOWNLOADING, isIndicating: true);
        }
      }
    );
  }

  Widget _karaokeScreenWidget() {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(song.name)
      ),
      resizeToAvoidBottomInset: true,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF000000)
            ),
            padding: EdgeInsets.only(top: 5.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: KaraokeVideoPlayer(
                    videoPlayerController: _videoPlayerController
                ),
              ),
              Expanded(
                flex: 3,
                child: KaraokeCameraRecorder(cameras: cameras),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _fetchCameras() async {
    // Fetch the available cameras before initializing the karaoke recorder.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print(e.code + e.description);
    }
  }
}