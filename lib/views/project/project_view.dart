import 'dart:ui';

import 'package:eep_bridge_host/components/event_listening_widget.dart';
import 'package:eep_bridge_host/components/sidebar.dart';
import 'package:eep_bridge_host/project/event/project_events.dart';
import 'package:eep_bridge_host/project/project.dart';
import 'package:eep_bridge_host/views/project/project_content_wrapper.dart';
import 'package:eep_bridge_host/views/project/project_statistics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectView extends StatefulWidget {
  final Project project;

  ProjectView({required this.project});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  late WidgetBuilder _currentChildBuilder;
  late String _currentTitle;
  late final List<_ProjectViewSidebarEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = [
      _ProjectViewSidebarEntry(
        active: true,
        icon: Icons.poll_outlined,
        text: Intl.message("Dashboard"),
        builder: (context) => ProjectStatistics(),
      ),
      _ProjectViewSidebarEntry(
        icon: Icons.engineering,
        text: Intl.message("Control"),
        builder: (context) => Center(),
      ),
      _ProjectViewSidebarEntry(
        icon: Icons.departure_board_outlined,
        text: Intl.message("Schedule"),
        builder: (context) => Center(),
      ),
      _ProjectViewSidebarEntry(
          icon: Icons.bug_report,
          text: Intl.message("Debug"),
          builder: (context) => Center()),
    ];
    _currentChildBuilder = _entries[0].builder;
    _currentTitle = _entries[0].text;
  }

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
                _ProjectViewSidebar(
                  project: widget.project,
                  entries: _entries,
                  callback: _onEntryIndexChanged,
                ),
                ProjectContentWrapper(
                  child: _currentChildBuilder(context),
                  project: widget.project,
                  title: _currentTitle,
                )
              ],
            )
          ],
        ),
      );

  void _onEntryIndexChanged(int newIndex) => setState(() {
    _currentChildBuilder = _entries[newIndex].builder;
    _currentTitle = _entries[newIndex].text;
  });
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

class _ProjectViewSidebarEntry {
  IconData icon;
  String text;
  WidgetBuilder builder;
  bool active;

  _ProjectViewSidebarEntry(
      {required this.icon,
      required this.text,
      required this.builder,
      this.active = false});
}

typedef IndexCallback = void Function(int i);

class _ProjectViewSidebar extends StatefulWidget {
  final Project project;
  final List<_ProjectViewSidebarEntry> entries;
  final IndexCallback callback;

  _ProjectViewSidebar({
    Key? key,
    required this.project,
    required this.entries,
    required this.callback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectViewSidebarState();
}

class _ProjectViewSidebarState extends State<_ProjectViewSidebar> {
  @override
  Widget build(BuildContext context) => Sidebar(
      children: <Widget>[
            SidebarSection(text: Intl.message("MENU")),
          ] +
          List.generate(
              widget.entries.length,
              (i) => SidebarEntry(
                    icon: widget.entries[i].icon,
                    text: widget.entries[i].text,
                    active: widget.entries[i].active,
                    onTap: () {
                      setState(() {
                        widget.entries.forEach((e) => e.active = false);
                        widget.entries[i].active = true;
                      });

                      widget.callback(i);
                    },
                  )) +
          [
            Spacer(),
            SizedBox(
              height: 20,
            ),
            _TogglePauseButton(
              project: widget.project,
            ),
            SizedBox(
              height: 40,
            )
          ]);
}
