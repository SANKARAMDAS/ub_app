import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    @required this.child,
    @required this.value,
    this.color,
    this.countColor
  }) : super(key: key);

  final Widget? child;
  final String? value;
  final Color? color;
  final Color? countColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child??Container(),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color != null ? color : Theme.of(context).primaryColor,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value??'',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: countColor
              ),
            ),
          ),
        )
      ],
    );
  }
}
