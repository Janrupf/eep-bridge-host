import 'dart:async';

import 'package:eep_bridge_host/components/create_project_dialog.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/util/ui_messenger.dart';
import 'package:eep_bridge_host/views/waiting_view.dart';
import 'package:flutter/material.dart';

/// Overview for each project
class ViewportWrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewportWrapperState();
}

class _ViewportWrapperState extends State<ViewportWrapper> {
  late final StreamSubscription<UIMessageEvent<dynamic, dynamic>> _subscription;

  bool _isWaiting = true;

  @override
  void initState() {
    super.initState();
    _subscription = UIMessenger.eventStream.listen(_onUIEvent);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isWaiting) {
      return WaitingView();
    } else {
      return Scaffold(body: Text("ABC!"));
    }
  }

  void _onUIEvent(UIMessageEvent<dynamic, dynamic> event) {
    if (event.payload is CreateProjectRequest) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => CreateProjectDialog(
              event as UIMessageEvent<CreateProjectRequest, String?>));
    }
  }
}
