import 'package:flutter/material.dart';
import 'package:flutter_camera/pages/camera_page.dart';
import 'package:flutter_camera/pages/image_picker_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Camera Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          CameraPage.pageRoute: (BuildContext context) =>
              CameraPage(title: 'Camera Page'),
          ImagePickerPage.pageRoute: (BuildContext context) =>
              ImagePickerPage(title: 'Image Picker Page'),
        });
  }
}
