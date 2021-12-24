import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  final String url;
  const PhotoViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Text(url.split('/').last),
      ),
      body: Container(
          alignment: Alignment.center,
          child: PhotoView(
        imageProvider: NetworkImage(url),
      )),
    );
  }
}

class PhotoViewer2 extends StatelessWidget {
  final String filePath;
  const PhotoViewer2({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.of(context).pop();
        },),
        title: Text(filePath.split('/').last),
      ),
      body: Container(
        alignment: Alignment.center,
        child: InteractiveViewer(
          child: Image.file(
            File(filePath),
          ),
        ),
      ),
    );
  }
}
