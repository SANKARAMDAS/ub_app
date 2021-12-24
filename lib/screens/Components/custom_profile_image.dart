import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';

class CustomProfileImage extends StatefulWidget {
  final Uint8List? avatar;
  final String? name;
  final String? mobileNo;

  CustomProfileImage({Key? key, this.avatar, this.name, this.mobileNo})
      : super(key: key);

  @override
  _CustomProfileImageState createState() => _CustomProfileImageState();
}

class _CustomProfileImageState extends State<CustomProfileImage> {
  final List<Color> _colors = [
    Color.fromRGBO(137, 171, 249, 1),
    AppTheme.brownishGrey,
    AppTheme.greyish,
    AppTheme.electricBlue,
  ];

  final random = Random();
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = _colors[random.nextInt(_colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: selectedColor,
        backgroundImage: widget.avatar == null || widget.avatar!.isEmpty
            ? null
            : MemoryImage(widget.avatar!),
        child: widget.avatar == null || widget.avatar!.isEmpty
            ? CustomText(
                getInitials(widget.name?.trim()??'User', widget.mobileNo?.trim() ?? '').toUpperCase(),
                color: AppTheme.circularAvatarTextColor,
                size: 22,
              )
            : null,
      ),
    );
  }
}
