import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vplayer/Karaoke.dart';

class KaraokeCameraRecorder extends StatefulWidget {
  KaraokeCameraRecorder({Key key, @required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  _KaraokeCameraRecorderState createState() => _KaraokeCameraRecorderState(cameras);
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return CupertinoIcons.switch_camera;
    case CameraLensDirection.front:
      return CupertinoIcons.switch_camera_solid;
    case CameraLensDirection.external:
      return CupertinoIcons.photo_camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _KaraokeCameraRecorderState extends State<KaraokeCameraRecorder> with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;

  List<CameraDescription> cameras;

  _KaraokeCameraRecorderState(this.cameras);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected(cameras.first);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if(controller.value.isRecordingVideo){
      onStopButtonPressed();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: _videoCameraPreviewWidget(),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  border: Border.all(
                    color: controller != null && controller.value.isRecordingVideo
                        ? Color(0xFF00BFFF)
                        : Color(0xFFC2C2C2),
                    width: 1.0,
                  ),
                ),
              ),
              Positioned.fill(
                top: height - 460.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  _recordControlWidget(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _videoCameraPreviewWidget() {
    return AspectRatio(
        aspectRatio: 0.91,//controller.value.aspectRatio,
        child: CameraPreview(controller)
    );
  }

  /// Display the control button to record videos.
  Widget _recordControlWidget(){
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: width,
        height: 100,
        decoration: BoxDecoration(
            color: Color(0x40FFFFFF)
        ),
        padding: EdgeInsets.all(8.0),
        child: CupertinoButton(
          color: Color(0x000000),
          child: _cameraControlWidget(),
          pressedOpacity: 0.5,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : onStopButtonPressed,
        ),
      ),
    );
  }

  Widget _cameraControlWidget(){
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35.0),
          border: Border.all(
              color: controller != null && controller.value.isRecordingVideo
                  ? Color(0xFF00BFFF)
                  : Color(0xFFFFFFFF)
          ),
          color: controller != null && controller.value.isRecordingVideo
              ? Color(0xFFFF0000)
              : Color(0xFF00BFFF)
      ),
      child: Center(
        child: controller != null && controller.value.isRecordingVideo
            ? Icon(CupertinoIcons.share, size: 30.0, color: Color(0xFF00BFFF))
            : Icon(CupertinoIcons.video_camera, size: 30.0, color: Color(0xFFFFFFFF)),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    print("SnackBar message::: " + message);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      await controller.prepareForVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }


  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) {
        showInSnackBar('Saving video to $filePath');
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      GallerySaver.saveVideo(videoPath);
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}' + Karaoke.SAVED_VIDEO_PATH;
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      print("FILE LOCATION: " + filePath);
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    //await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}