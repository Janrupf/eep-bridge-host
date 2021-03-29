import 'dart:ui';

import 'package:eep_bridge_host/components/event_listening_widget.dart';
import 'package:eep_bridge_host/components/sidebar.dart';
import 'package:eep_bridge_host/project/event/project_events.dart';
import 'package:eep_bridge_host/project/project.dart';
import 'package:eep_bridge_host/views/project/project_content_wrapper.dart';
import 'package:eep_bridge_host/views/project/project_statistics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectView extends StatelessWidget {
  final Project project;

  ProjectView({required this.project});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage("assets/dioramas/Diorama_02.png"),
                    fit: BoxFit.cover),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(
                  decoration:
                      BoxDecoration(color: Color(0x171717).withOpacity(0.7)),
                ),
              ),
            ),
            Row(
              children: [
                _sidebar(context),
                ProjectContentWrapper(
                  child: ProjectStatistics(),
                  project: project,
                )
              ],
            )
          ],
        ),
      );

  Widget _sidebar(BuildContext context) => Sidebar(children: [
        SidebarSection(text: Intl.message("MENU")),
        SidebarEntry(
            active: true,
            icon: Icons.poll_outlined,
            text: Intl.message("Dashboard"),
            onTap: () {}),
        SidebarEntry(
            icon: Icons.engineering,
            text: Intl.message("Control"),
            onTap: () {}),
        SidebarEntry(
            icon: Icons.departure_board_outlined,
            text: Intl.message("Schedule"),
            onTap: () {}),
        Spacer(),
        _TogglePauseButton(
          project: project,
        ),
        SizedBox(
          height: 40,
        )
      ]);
}

class _TogglePauseButton extends StatelessWidget {
  final Project project;

  _TogglePauseButton({required this.project});

  @override
  Widget build(BuildContext context) =>
      EventListening<ProjectControlStateChangeEvent>(
        builder: (context, event) {
          if (event == null) {
            project.requestControlStateEvent();
            return _createButton(
                context: context,
                text: Intl.message("NO CLIENT"),
                icon: Icon(Icons.play_arrow),
                color: Theme.of(context).buttonColor,
                onPressed: null);
          }

          if (event.state == ProjectControlState.noClient ||
              event.state == ProjectControlState.paused) {
            VoidCallback? playCallback =
                event.state == ProjectControlState.noClient
                    ? null
                    : _onPlayClicked;

            return _createButton(
                context: context,
                text: Intl.message("PLAY"),
                icon: Icon(Icons.play_arrow),
                color: Theme.of(context).buttonColor,
                onPressed: playCallback);
          }

          return _createButton(
              context: context,
              text: Intl.message("PAUSE"),
              icon: Icon(Icons.pause),
              color: Theme.of(context).errorColor,
              onPressed: _onPauseClicked);
        },
        stream: project.stream,
      );

  Widget _createButton(
          {required BuildContext context,
          required String text,
          required Icon icon,
          required Color color,
          VoidCallback? onPressed}) =>
      Container(
        width: 205,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3), blurRadius: 50, spreadRadius: 5)
        ]),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                textStyle: Theme.of(context).textTheme.headline5,
                primary: color),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(text), icon],
            ),
            onPressed: onPressed),
      );

  void _onPlayClicked() {
    project.paused = false;
  }

  void _onPauseClicked() {
    project.paused = true;
  }
}
