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
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            Center(
                child: GestureDetector(
              child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'image-picker',
                  )),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, ImagePickerPage.pageRoute);
              },
            ))
          ],
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
  CameraDescription _activeCamera;

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

  String _getLensDirectionText(CameraLensDirection lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return "Задняя";
        break;
      case CameraLensDirection.front:
        return "Фронтальная";
        break;
      case CameraLensDirection.external:
        return "Внешняя";
        break;
    }
  }

  Widget _lensControl(CameraDescription cameraDescription) {
    String text = _getLensDirectionText(cameraDescription.lensDirection);
    return RaisedButton(
      child: Text("$text ${cameraDescription.name}"),
      onPressed: () {
        setState(() {
          _activeCamera = cameraDescription;
          _setCameraController(cameraDescription);
        });
      },
    );
  }

  void _setCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraListWidget() {
    final List<Widget> cameras = <Widget>[];
    if (_cameras == null || _cameras.isEmpty) {
      return Text('Камеры не обнаружены');
    } else {
      for (CameraDescription cameraDescription in _cameras) {
        cameras.add(_lensControl(cameraDescription));
      }
    }

    return Flexible(
        fit: FlexFit.loose,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: cameras));
  }

  Widget _getActiveCamera() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          _activeCamera == null
              ? "Выберите камеру"
              : _getLensDirectionText(_activeCamera.lensDirection) +
                  ' ' +
                  _activeCamera.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));
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
          _getActiveCamera(),
          _cameraListWidget(),
          RaisedButton.icon(
            icon: Icon(Icons.photo_camera),
            label: Text("Сделать фотографию"),
            onPressed: _activeCamera == null ? null : _takePhoto,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ));
  }
}
