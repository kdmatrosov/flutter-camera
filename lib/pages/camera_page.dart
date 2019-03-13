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
        body: _CameraView());
  }
}

class _CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<_CameraView> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  CameraLensDirection _cameraLensDirection;

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  Future<void> _getAvailableCameras() async {
    try {
      final cameras = await availableCameras();
      setState(() {
        _cameras = cameras;
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        _cameraLensDirection = _controller.description.lensDirection;
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

  Widget _cameraView() {
    if (_controller == null || !_controller.value.isInitialized) {
      return Placeholder();
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller));
  }

  void _takePhoto() {}

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }

  Widget _lensControl() {
    return RaisedButton(
      child: Text(""),
      onPressed: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            child: _cameraView(),
            height: 300,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.photo_camera),
            label: Text("Сделать фотографию"),
            onPressed: null,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ));
  }
}
