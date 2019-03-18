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

  void _getImageFromPhotoLibrary() {
    _getImage(ImageSource.gallery);
  }

  void _getPhotoFromCamera() {
    _getImage(ImageSource.camera);
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final File file = await ImagePicker.pickImage(source: source);
      setState(() => _image = file);
    } catch (e) {
      print(e);
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
          SizedBox(
            child: _image != null ? Image.file(_image) : Placeholder(),
            height: 300,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.photo_camera),
            label: Text("Сделать фотографию"),
            onPressed: _getPhotoFromCamera,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("Выбрать из каталога"),
            onPressed: _getImageFromPhotoLibrary,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ));
  }
}
