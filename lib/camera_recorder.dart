import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vplayer/Karaoke.dart';

class KaraokeCameraRecorder extends StatefulWidget {
  KaraokeCameraRecorder({Key key, @required this.cameraDescription}) : super(key: key);
  final CameraDescription cameraDescription;

  @override
  _KaraokeCameraRecorderState createState() => _KaraokeCameraRecorderState(cameraDescription);
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
  CameraController cameraController;
  CameraDescription cameraDescription;
  String imagePath;
  String videoPath;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;

  _KaraokeCameraRecorderState(this.cameraDescription);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected(cameraDescription);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if(cameraController.value.isRecordingVideo){
      onStopButtonPressed();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        onNewCameraSelected(cameraController.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 1.0, left: 1.0),
              child: _videoCameraPreviewWidget(),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF000000),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child:  _recordControlWidget(),
            ),
          )
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _videoCameraPreviewWidget() {
    double size = MediaQuery.of(context).size.width;
    double h = cameraController != null && cameraController.value.isInitialized
        ? cameraController.value.aspectRatio
        : 1;

    return Container(
      width: size,//controller.value.aspectRatio,
      height: size,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              width: size,
              height: size / h,
              child: CameraPreview(cameraController),
            ),
          ),
        ),
      )
    );
  }

  /// Display the control button to record videos.
  Widget _recordControlWidget(){
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width - 2,
      decoration: BoxDecoration(
          color: Color(0x40000000)
      ),
      padding: EdgeInsets.only(left: 1.0, right: 1.0),
      child: CupertinoButton(
        color: Color(0x000000),
        child: _cameraControlWidget(),
        pressedOpacity: 0.5,
        onPressed: cameraController != null &&
            cameraController.value.isInitialized &&
            !cameraController.value.isRecordingVideo
            ? onVideoRecordButtonPressed
            : onStopButtonPressed,
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
              color: cameraController != null && cameraController.value.isRecordingVideo
                  ? Color(0xFF00BFFF)
                  : Color(0xFFFFFFFF)
          ),
          color: cameraController != null && cameraController.value.isRecordingVideo
              ? Color(0xFFFF0000)
              : Color(0xFF00BFFF)
      ),
      child: Center(
        child: cameraController != null && cameraController.value.isRecordingVideo
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
    if (cameraController != null) {
      await cameraController.dispose();
    }

    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await cameraController.prepareForVideoRecording();
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
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}' + Karaoke.SAVED_VIDEO_PATH;
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      print("FILE LOCATION: " + filePath);
      videoPath = filePath;
      await cameraController.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    //await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<String> takePicture() async {
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await cameraController.takePicture(filePath);
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