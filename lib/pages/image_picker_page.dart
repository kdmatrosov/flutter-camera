import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera/pages/camera_page.dart';
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
  File _image;

  void _getImageFromPhotoLibrary(context) {
    _getImage(ImageSource.gallery, context);
  }

  void _getPhotoFromCamera(context) {
    _getImage(ImageSource.camera, context);
  }

  Future<void> _getImage(ImageSource source, BuildContext context) async {
    try {
      print(source);
      final File file = await ImagePicker.pickImage(source: source);
      setState(() {
        _image = file;
        _showBottomSheet(context);
      });
    } catch (e) {
      print(e);
    }
  }

  void _showBottomSheet(context) {
    if (_image != null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return LimitedBox(
              child: Image.file(_image),
              maxHeight: 300,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.photo_camera),
            label: Text("Сделать фотографию"),
            onPressed: () {
              _getPhotoFromCamera(context);
            },
          ),
          RaisedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("Выбрать из каталога"),
            onPressed: () {
              _getImageFromPhotoLibrary(context);
            },
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ));
  }
}
