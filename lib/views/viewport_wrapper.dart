import 'dart:async';

import 'package:eep_bridge_host/components/dialogs/base_dialog.dart';
import 'package:eep_bridge_host/components/dialogs/create_project_dialog.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/util/ui_messenger.dart';
import 'package:eep_bridge_host/views/project_view.dart';
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
    return ProjectView();
    // if (_isWaiting) {
    //   return MainMenu();
    // } else {
    //   return Scaffold(body: Text("ABC!"));
    // }
  }

  void _onUIEvent(UIMessageEvent<dynamic, dynamic> event) {
    if (event.payload is CreateProjectRequest) {
      showBaseDialog(
          context: context,
          dialog: CreateProjectDialog(
              event as UIMessageEvent<CreateProjectRequest, String?>));
    }
  }
}
