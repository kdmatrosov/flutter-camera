import 'package:flutter/material.dart';
import 'package:flutter_camera/camera_view.dart';
import 'package:flutter_camera/image_picker_view.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraPage(title: 'Flutter Camera Page'),
    );
  }
}

class CameraPage extends StatefulWidget {
  CameraPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.camera_alt),
                  text: "camera",
                ),
                Tab(
                  icon: Icon(Icons.camera_roll),
                  text: "image_picker",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [CameraView(), ImagePickerView()],
          )),
    );
  }
}
