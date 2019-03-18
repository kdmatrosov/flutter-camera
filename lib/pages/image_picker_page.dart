import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera/pages/camera_page.dart';
import 'package:flutter_camera/widgets/video.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  static final String pageRoute = "/picker";

  ImagePickerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
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
                  'сamera',
                )),
            onTap: () {
              Navigator.pushReplacementNamed(context, CameraPage.pageRoute);
            },
          ))
        ],
      ),
      body: _ImagePickerView(),
    );
  }
}

class _ImagePickerView extends StatefulWidget {
  @override
  _ImagePickerViewState createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<_ImagePickerView> {
  File _file;
  bool _isVideo = false;

  void _getImageFromPhotoLibrary(context) {
    _getFile(ImageSource.gallery, context);
  }

  void _getFromCamera(context) {
    _getFile(ImageSource.camera, context);
  }

  Future<void> _getFile(ImageSource source, BuildContext context) async {
    try {
      print(source);
      final File file = _isVideo
          ? await ImagePicker.pickVideo(source: source)
          : await ImagePicker.pickImage(source: source);
      setState(() {
        _file = file;
        _showBottomSheet(context);
      });
    } catch (e) {
      print(e);
    }
  }

  void _showBottomSheet(context) {
    if (_file != null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Center(
                child: LimitedBox(
              child: _isVideo ? Video(_file) : Image.file(_file),
              maxHeight: 300,
            ));
          });
    }
  }

  String get buttonText => !_isVideo ? "Сделать фотографию" : "Записать видео";

  IconData get buttonIcon => !_isVideo ? Icons.photo_camera : Icons.videocam;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton.icon(
            icon: Icon(buttonIcon),
            label: Text(buttonText),
            onPressed: () {
              _getFromCamera(context);
            },
          ),
          RaisedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("Выбрать из каталога"),
            onPressed: () {
              _getImageFromPhotoLibrary(context);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Фото'),
              Switch(
                onChanged: (bool value) {
                  setState(() {
                    _isVideo = value;
                  });
                },
                value: _isVideo,
              ),
              Text('Видео'),
            ],
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ));
  }
}
