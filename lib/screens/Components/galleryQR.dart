import 'package:flutter/material.dart';
// import 'package:qrscan/qrscan.dart';

class GalleryQRButton extends StatelessWidget {
  const GalleryQRButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  IconButton(
          icon: Image.asset(
            'assets/icons/Image-01.png',
            width: 70,
          ),
          onPressed: () async {},
        );
  }
}