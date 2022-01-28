import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_services.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final double? width;
  final Widget? prefixIcon;
  final double? iconGap;
  final double? height;
  final Function? onTap;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry? padding;

  CustomButton(
      {required this.label,
      this.width,
      this.prefixIcon,
      this.iconGap,
      this.height,
      this.onTap,
      this.color,
      this.padding,
      this.radius});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color ?? AppTheme.electricBlue,
            borderRadius: BorderRadius.circular(widget.radius ?? 0)),
        width: widget.width,
        height: widget.height,
        padding: widget.padding ?? EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.prefixIcon != null ? widget.prefixIcon! : SizedBox.shrink(),
            SizedBox(width: widget.iconGap),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
