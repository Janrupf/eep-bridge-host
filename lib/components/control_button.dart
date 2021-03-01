import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool warn;

  const ControlButton(
      {Key? key, required this.child, this.onPressed, this.warn = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        textStyle: Theme.of(context).textTheme.headline5,
        primary: _color(context),
      ),
      onPressed: onPressed,
      child: child);

  Color _color(BuildContext context) =>
      warn ? Theme.of(context).errorColor : Theme.of(context).buttonColor;
}
