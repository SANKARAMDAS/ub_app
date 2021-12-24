import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget> children;
  final EdgeInsetsGeometry? tilePadding;
  final EdgeInsetsGeometry? childrenPadding;
  final double? trailingIconSize;
  final bool initiallyExpanded;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    this.initiallyExpanded: false,
    this.leading,
    this.children = const <Widget>[],
    this.tilePadding,
    this.trailingIconSize,
    this.childrenPadding,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late GlobalKey key;
  late Animation<double> _iconTurns;
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  late AnimationController _controller;

  // get key => GlobalKey();

  @override
  void initState() {
    key = GlobalKey();
    if (!isExpanded)
      _controller = AnimationController(duration: _kExpand, vsync: this);
    isExpanded = false;
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: key,
        tilePadding: widget.tilePadding,
        title: widget.title,
        leading: widget.leading,
        trailing: RotationTransition(
          turns: _iconTurns,
          child: Icon(
            !isExpanded ? Icons.chevron_right_rounded : Icons.expand_more,
            size: widget.trailingIconSize,
          ),
        ),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        children: widget.children,
        childrenPadding: widget.childrenPadding,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
