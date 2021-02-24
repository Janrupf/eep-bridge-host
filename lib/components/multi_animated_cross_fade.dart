import 'dart:async';

import 'package:flutter/material.dart';

class MultiAnimatedCrossFade extends StatefulWidget {
  final List<Widget> children;
  final Duration changeDuration;
  final Duration displayDuration;

  MultiAnimatedCrossFade(
      {Key? key,
      required this.children,
      required this.changeDuration,
      required this.displayDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiAnimatedCrossFadeState();
}

class _MultiAnimatedCrossFadeState extends State<MultiAnimatedCrossFade> {
  late final Timer _displayTimer;

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _displayTimer = Timer.periodic(widget.displayDuration, (timer) => _swap());
  }

  @override
  void dispose() {
    _displayTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: widget.changeDuration,
        child: widget.children[_index],
      );

  void _swap() {
    if (!mounted) {
      return;
    }

    setState(() {
      _index = (_index + 1) % widget.children.length;
    });
  }
}
