import 'dart:async';

import 'package:flutter/material.dart';

/// Function which rebuilds a widget when an [event] of the type [E] occurs.
typedef Widget EventWidgetBuilder<E>(BuildContext context, E? event);

/// Wrapper widget for rebuilding widgets when an event of the type [E] occurs.
class EventListening<E> extends StatefulWidget {
  final Stream<dynamic> stream;
  final EventWidgetBuilder<E> builder;

  /// Creates a new wrapper widget which listens to a [stream], rebuilding using
  /// a [builder] when the stream emits a value of a certain type [E].
  EventListening({required this.stream, required this.builder, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventListeningState<E>();
}

class _EventListeningState<E> extends State<EventListening<E>> {
  late final StreamSubscription<dynamic> _subscription;
  E? _event;
  
  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(_onEvent);
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => widget.builder(context, _event);
  
  void _onEvent(dynamic event) {
    if(event is E && mounted) {
      setState(() {
        _event = event;
      });
    }
  }
}
