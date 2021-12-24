import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget title;
  final bool? automaticallyImplyLeading;

  CustomAppBar({
    required this.title,
    this.actions,
    this.automaticallyImplyLeading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      automaticallyImplyLeading: automaticallyImplyLeading!,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          color: Color(0xFFDDDDDD),
          height: 1,
        ),
      ),
      elevation: 0,
      title: title,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56);
}
