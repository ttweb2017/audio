import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/camera_recorder.dart';
import 'package:vplayer/model/song.dart';
import 'package:vplayer/splash_screen.dart';
import 'package:vplayer/util/cache_manager.dart';
import 'package:vplayer/video_payer.dart';
import 'package:gallery_saver/gallery_saver.dart';

class KaraokeScreen extends StatefulWidget {
  KaraokeScreen({Key key, @required this.song}) : super(key: key);
  final Song song;

  @override
  _KaraokeScreenState createState() => _KaraokeScreenState(song);
}

class _KaraokeScreenState extends State<KaraokeScreen> {
  CameraController _cameraController;
  VideoPlayerController _videoPlayerController;
  VoidCallback listener;
  List<CameraDescription> cameras;
  Future<void> _initializeVideoPlayerFuture;
  bool isCameraReady = false;

  var fetchedFile;

  CustomCacheManager cacheManager = CustomCacheManager();

  bool enableAudio = true;

  Song song;
  _KaraokeScreenState(this.song);

  @override
  void initState() {
    // TODO: Karaoke screen implement initState
    listener = (){
      setState(() {

      });
    };

    _dowloadVideoFile(song.fullVideoUrl);

    _fetchCameras();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: Karaoke screen implement dispose
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.dispose();
    isCameraReady = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done && isCameraReady){
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
          middle: Text(song.name),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      resizeToAvoidBottomInset: true,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF000000)
            ),
            //padding: EdgeInsets.only(top: 5.0),
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
                child: KaraokeCameraRecorder(
                    cameraController: _cameraController
                ),
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

      _cameraController = CameraController(
        cameras.last,
        ResolutionPreset.medium,
        enableAudio: enableAudio,
      );

      _cameraController.initialize();
      _cameraController.prepareForVideoRecording().then((_){
        setState(() {
          isCameraReady = true;
        });
      });

    } on CameraException catch (e) {
      print(e.code + e.description);
    }
  }

  //download a fucking video
  Future<void> _dowloadVideoFile(String url) async {
    fetchedFile = await cacheManager.getSingleFile(url);

    _videoPlayerController = VideoPlayerController.file(
        fetchedFile
    )..addListener(listener);

    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }
}