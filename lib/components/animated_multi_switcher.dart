import 'dart:async';

import 'package:flutter/material.dart';

/// Widget modeled after (and using) [AnimatedSwitcher] to animate between
/// multiple children.
class AnimatedMultiSwitcher extends StatefulWidget {
  final List<Widget> children;
  final Duration transitionDuration;
  final Duration displayDuration;

  /// Initializes the switcher and sets the widgets it switches between.
  /// 
  /// [children] are the widgets to switch between, while [displayDuration]
  /// determines for how to long show each child after which a transition
  /// taking [transitionDuration] takes place.
  AnimatedMultiSwitcher(
      {Key? key,
      required this.children,
      required this.transitionDuration,
      required this.displayDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedMultiSwitcherState();
}

class _AnimatedMultiSwitcherState extends State<AnimatedMultiSwitcher> {
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
        duration: widget.transitionDuration,
        child: widget.children[_index],
      );

  /// Swaps the child by incrementing the index, wrapping around if necessary.
  void _swap() {
    setState(() {
      _index = (_index + 1) % widget.children.length;
    });
  }
}
