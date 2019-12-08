import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/camera_recorder.dart';
import 'package:vplayer/karaoke_main_screen.dart';
import 'package:vplayer/model/song.dart';
import 'package:vplayer/splash_screen.dart';
import 'package:vplayer/util/cache_manager.dart';
import 'package:vplayer/video_payer.dart';

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
  bool isError = false;

  var fetchedFile;

  CustomCacheManager cacheManager = CustomCacheManager();

  bool enableAudio = true;

  Song song;
  _KaraokeScreenState(this.song);

  @override
  void initState() {
    listener = (){
      setState(() {

      });
    };

    _fetchCameras();

    _downloadVideoFile(song.fullVideoUrl);

    super.initState();
  }

  @override
  void dispose() {
    if(_videoPlayerController != null){
      _videoPlayerController.removeListener(listener);
      _videoPlayerController.dispose();
    }

    if(_cameraController != null){
      _cameraController.dispose();
    }

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
                    cameraDescription: cameras.last,
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

      setState(() {
        isCameraReady = true;
      });

    } on CameraException catch (e) {
      print(e.code + e.description);
    }
  }

  //download a fucking video
  Future<void> _downloadVideoFile(String url) async {
    await cacheManager.getSingleFile(url)
        .then((onValue){
          print("Loaded file::::: " + onValue.path);
          _videoPlayerController = VideoPlayerController.file(
              onValue
          )..addListener(listener);

          _initializeVideoPlayerFuture = _videoPlayerController.initialize();
        })
        .catchError((onError){
          print("Loading file error::: " + onError.toString());
          _videoPlayerController = null;
          _initializeVideoPlayerFuture = null;
        });
  }

  Widget _showAlertDialog(){
    return CupertinoAlertDialog(
      title: new Text("Connection Error"),
      content: new Text("Please check your internet!"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("OK"),
          onPressed: (){
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) => KaraokePage(
                  title: Karaoke.APP_TITLE,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}