import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ViewPhotoScreen extends StatefulWidget {
  ViewPhotoScreen({Key key, this.image}) : super(key: key);

  final Blob image;

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  Base64Codec base64 = Base64Codec();

  @override
  Widget build(BuildContext context) {
    Blob a = widget.image;
    var b = 'hola';
    return Scaffold(
        appBar: AppBar(
          title: Text('La foto que tomé'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 500, height: 500,
            //child: Text('hola'),
            child: Image.memory(base64.decode(widget.image.toString())),
          ),
        ));
  }
}
