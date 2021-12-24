import 'package:flutter/material.dart';

class NewCustomButton extends StatelessWidget {
  final void Function()? onSubmit;
  final String text;
  final double textSize;
  final Color textColor;
  final Color? imageColor;
  final Color? backgroundColor;
  final String? prefixImage;
  final Color? prefixImageColor;
  final String? suffixImage;
  final Color? suffixImageColor;
  final double? imageSize;
  final int? elevated;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;

  NewCustomButton({
    required this.onSubmit,
    required this.text,
    required this.textSize,
    required this.textColor,
    this.backgroundColor,
    this.prefixImage,
    this.prefixImageColor,
    this.suffixImage,
    this.suffixImageColor,
    this.imageSize,
    this.elevated,
    this.imageColor,
    this.fontWeight,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width,
      // child:Expanded(
      //   flex: 1,
      child: Scrollbar(
        child: ElevatedButton(
          // style: ElevatedButton.styleFrom(
          //   primary: AppTheme.electricBlue,
          //   onPrimary: Colors.white,
          //   shadowColor: Colors.black12,
          //   elevation: 2,
          //   shape: OutlinedBorder(
          //     RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(18.0),
          //       side: BorderSide(color: Colors.red)
          //     )
          //   )
          // ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color?>(backgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                // side: BorderSide(color: Colors.red)
              ))),
          onPressed: onSubmit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixImage != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                  ),
                  child: Image.asset(
                    prefixImage.toString(),
                    height: imageSize,
                    color: imageColor,
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.006,
                    vertical: MediaQuery.of(context).size.height * 0.013),
                child: Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: fontWeight),
                ),
              ),
              if (suffixImage != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Image.asset(
                    suffixImage.toString(),
                    height: imageSize,
                    color: imageColor,
                  ),
                ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

class PayCustomButton extends StatelessWidget {
  final void Function()? onSubmit;
  final String text1;
  final double textSize1;
  final Color textColor1;
  final String text2;
  final double textSize2;
  final Color textColor2;
  final Color? imageColor1;
  final Color? imageColor2;
  final Color? backgroundColor;
  final String? prefixImage1;
  final String? prefixImage2;
  final Color? prefixImageColor;
  final String? suffixImage1;
  final String? suffixImage2;
  final Color? suffixImageColor;
  final double? imageSize1;
  final double? imageSize2;
  final int? elevated;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;

  PayCustomButton({
    required this.onSubmit,
    required this.text1,
    required this.textSize1,
    required this.textColor1,
    required this.text2,
    required this.textSize2,
    required this.textColor2,
    this.backgroundColor,
    this.prefixImage1,
    this.prefixImage2,
    this.prefixImageColor,
    this.suffixImage1,
    this.suffixImage2,
    this.suffixImageColor,
    this.imageSize1,
    this.imageSize2,
    this.elevated,
    this.imageColor1,
    this.imageColor2,
    this.fontWeight,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width,
      // child:Expanded(
      //   flex: 1,
      child: Scrollbar(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color?>(backgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                // side: BorderSide(color: Colors.red)
              ))),
          onPressed: onSubmit,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixImage1 != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: Image.network(
                        prefixImage1.toString(),
                        height: imageSize1,
                        color: imageColor1,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Text(
                      text1,
                      style: TextStyle(
                          color: textColor1,
                          fontSize: textSize1,
                          fontWeight: fontWeight),
                    ),
                  ),
                  if (suffixImage1 != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Image.asset(
                        suffixImage1.toString(),
                        height: imageSize2,
                        color: imageColor1,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixImage2 != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: Image.asset(
                        prefixImage2.toString(),
                        height: imageSize2,
                        color: imageColor2,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Text(
                      text2,
                      style: TextStyle(
                          color: textColor2,
                          fontSize: textSize2,
                          fontWeight: fontWeight),
                    ),
                  ),
                  if (suffixImage2 != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Image.asset(
                        suffixImage2.toString(),
                        height: imageSize2,
                        color: imageColor2,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
