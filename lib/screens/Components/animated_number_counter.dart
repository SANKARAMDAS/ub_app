import 'package:flutter/material.dart';

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final num count;
  final TextStyle? style;

  AnimatedCount({
    Key? key,
    this.style,
    required this.count,
    required Duration duration,
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedCountState();
  }
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween? _intCount;
  Tween<double>? _doubleCount;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    if (widget.count is int) {
      _intCount = visitor(
        _intCount,
        widget.count,
        (dynamic value) => IntTween(begin: value),
      ) as IntTween;
    } else {
      _doubleCount = visitor(
        _doubleCount,
        widget.count,
        (dynamic value) => Tween<double>(begin: value),
      ) as Tween<double>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.count is int
        ? Text(
            _intCount?.evaluate(animation).toString() ?? 0.toString(),
            style: widget.style,
          )
        : Text(
            _doubleCount?.evaluate(animation).toStringAsFixed(2) ??
                0.00.toString(),
            style: widget.style,
          );
  }
}
