import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:web_test_rest/viewPhoto.dart';

class QRReadScreen extends StatefulWidget {
  @override
  _QRReadScreenState createState() => _QRReadScreenState();
}

class _QRReadScreenState extends State<QRReadScreen> {
  Widget _camera;
  html.VideoElement _cameraVideo;
  String key = UniqueKey().toString();
  var img;

  @override
  void initState() {
    // Create the video element
    _cameraVideo = new html.VideoElement();

    // Register the camera to the video element
    ui.platformViewRegistry
        .registerViewFactory('cameraVideo$key', (int viewId) => _cameraVideo);

    // Create the actual camera widget
    _camera = HtmlElementView(key: UniqueKey(), viewType: 'cameraVideo$key');

    // Access the camera stream
    html.window.navigator
        .getUserMedia(video: true)
        .then((html.MediaStream stream) {
      _cameraVideo.srcObject = stream;
    });

    // Start the camera feed
    _cameraVideo.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _camera),
      bottomNavigationBar: BottomAppBar(
          child: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () async {
                html.MediaStream cameraFeed = _cameraVideo.captureStream();
                html.MediaStreamTrack track = cameraFeed.getVideoTracks().first;
                html.ImageCapture image = new html.ImageCapture(track);
                html.Blob imageBlob = await image.takePhoto();

                Navigator.pop(context, imageBlob);

                //base64.decode(imageBlob.toString());
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ViewPhotoScreen(image: imageBlob)));
              })),
    );
  }

  @override
  void dispose() {
    // Turn the camera off
    html.MediaStream cameraFeed = _cameraVideo.captureStream();
    cameraFeed.getVideoTracks().forEach((track) {
      track.stop();
    });

    _cameraVideo.pause();
    _cameraVideo.removeAttribute('src');
    _cameraVideo.load();
    super.dispose();
  }
}
