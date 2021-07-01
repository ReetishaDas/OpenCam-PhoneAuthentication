import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_app/login_screen.dart';
import 'package:video_app/main.dart';
import 'package:video_app/view_videos.dart';

class CreateVideo extends StatefulWidget {
  @override
  _CreateVideoState createState() => _CreateVideoState();
}

String path;

class _CreateVideoState extends State<CreateVideo> {
  CameraController controller;
  Future<void> initializeControllerFuture;
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'VIDEO CAPTURE',
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ViewVideo()));
          },
          child: Icon(
            Icons.exit_to_app_outlined,
            size: 30.0,
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<void>(
            future: initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Center(
                      child: ElevatedButton(
                        child: Text('Back'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CameraPreview(controller),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: !controller.value.isRecordingVideo
                          ? RawMaterialButton(
                              onPressed: () async {
                                try {
                                  await initializeControllerFuture;
                                  path = join(
                                      (await getApplicationDocumentsDirectory())
                                          .path,
                                      '${DateTime.now()}.mp4');

                                  setState(() {
                                    controller.startVideoRecording();
                                    isDisabled = !isDisabled;
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Icon(
                                Icons.camera,
                                size: 50.0,
                                color: Colors.yellow,
                              ),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            )
                          : null,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: controller.value.isRecordingVideo
                            ? RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    if (controller.value.isRecordingVideo) {
                                      controller.stopVideoRecording();
                                      isDisabled = false;
                                      isDisabled = !isDisabled;
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.stop,
                                  size: 40.0,
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              )
                            : null),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
