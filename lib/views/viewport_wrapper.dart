import 'dart:async';

import 'package:eep_bridge_host/components/dialogs/base_dialog.dart';
import 'package:eep_bridge_host/components/dialogs/create_project_dialog.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/project/project.dart';
import 'package:eep_bridge_host/util/ui_messenger.dart';
import 'package:eep_bridge_host/views/main_menu.dart';
import 'package:eep_bridge_host/views/project_view.dart';
import 'package:flutter/material.dart';

/// Overview for each project
class ViewportWrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewportWrapperState();
}

class _ViewportWrapperState extends State<ViewportWrapper> {
  late final StreamSubscription<UIMessageEvent<dynamic, dynamic>> _subscription;

  Project? _currentProject;

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
    if (_currentProject == null) {
      return MainMenu();
    } else {
      return ProjectView(project: _currentProject!);
    }
  }

  void _onUIEvent(UIMessageEvent<dynamic, dynamic> event) {
    if (event.payload is CreateProjectRequest) {
      showBaseDialog(
          context: context,
          dialog: CreateProjectDialog(
              event as UIMessageEvent<CreateProjectRequest, String?>));
    } else if (event.payload is ShowProjectRequest) {
      setState(() {
        _currentProject = event.payload.project;
      });
    }
  }
}
