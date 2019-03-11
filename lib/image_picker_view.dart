import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerView extends StatefulWidget {
  @override
  _ImagePickerViewState createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _image != null
              ? Image.file(_image)
              : Placeholder(
                  fallbackHeight: 300,
                ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(),
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
