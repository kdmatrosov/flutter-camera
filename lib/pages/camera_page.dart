import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/pages/image_picker_page.dart';

class CameraPage extends StatefulWidget {
  static final String pageRoute = "/";

  CameraPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose plugin'),
              ),
              ListTile(
                title: Text('image-picker'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, ImagePickerPage.pageRoute);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(child: _CameraView()));
  }
}

class _CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<_CameraView> {
  List<CameraDescription> _cameras;
  CameraController _controller;

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  Future<void> _getAvailableCameras() async {
    try {
      final cameras = await availableCameras();
      print("cameras ${cameras.length}");
      cameras.forEach((c) {
        print(c.name);
      });
      setState(() {
        _cameras = cameras;
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        _controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      });
    } catch (e) {
      print("_getAvailableCameras $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller));
  }
}
