import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urbanledger/Utility/app_assets.dart';

class ULLogoWidget extends StatelessWidget {
  final double height;
  const ULLogoWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logo,
      height: height,
    );
  }
}
