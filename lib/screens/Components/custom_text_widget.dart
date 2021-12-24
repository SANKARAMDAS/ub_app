import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final double? size;
  final String data;
  final Color? color;
  final FontWeight? bold;
  final bool? italic;
  final bool? centerAlign;
  final TextDecoration? underline;
  final String? fontFamily;
  final double? height;
  final TextOverflow? overflow;

  const CustomText(
    this.data, {
    this.size,
    this.color,
    this.bold,
    this.underline,
    this.italic,
    this.centerAlign,
    this.fontFamily,
    this.height,
    this.overflow,
  });

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      textAlign: widget.centerAlign == null ? TextAlign.left : TextAlign.center,
      overflow: widget.overflow,
      style: TextStyle(
          height: widget.height,
          fontSize: widget.size,
          color: widget.color,
          fontWeight: widget.bold == null ? FontWeight.normal : widget.bold,
          fontFamily: widget.fontFamily ?? null,
          fontStyle:
              widget.italic == null ? FontStyle.normal : FontStyle.italic,
          decoration: widget.underline == null
              ? TextDecoration.none
              : TextDecoration.underline),
    );
  }
}
