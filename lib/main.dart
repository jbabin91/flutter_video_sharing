import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_publitio/flutter_publitio.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _videos = <String>[];

  bool _imagePickerActive = false;
  bool _uploading = false;

  @override
  void initState() {
    configurePublitio();
    super.initState();
  }

  static configurePublitio() async {
    await DotEnv().load('.env');
    await FlutterPublitio.configure(
        DotEnv().env['PUBLITIO_KEY'], DotEnv().env['PUBLITIO_SECRET']);
  }

  static _uploadVideo(videoFile) async {
    print('starting upload');
    final uploadOptions = {
      "privacy": "1",
      "option_download": "1",
      "option_transform": "1"
    };
    final response =
        await FlutterPublitio.uploadFile(videoFile.path, uploadOptions);
    return response;
  }

  void _takeVideo() async {
    if (_imagePickerActive) return;

    _imagePickerActive = true;
    final File videoFile =
        await ImagePicker.pickVideo(source: ImageSource.camera);
    _imagePickerActive = false;

    if (videoFile == null) return;

    setState(() {
      _uploading = true;
    });

    try {
      final response = await _uploadVideo(videoFile);
      setState(() {
        _videos.add(response["url_preview"]);
      });
    } on PlatformException catch (e) {
      print('${e.code}, ${e.message}');
      // result = 'Platform Exception: ${e.code} ${e.details}';
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _videos.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(_videos[index]),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeVideo,
        tooltip: 'Take Video',
        child: _uploading
            ? CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Icon(Icons.add),
      ),
    );
  }
}
