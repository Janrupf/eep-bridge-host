import 'package:eep_bridge_host/components/event_listening_widget.dart';
import 'package:eep_bridge_host/project/event/project_events.dart';
import 'package:eep_bridge_host/project/project.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectContentWrapper extends StatelessWidget {
  final Widget child;
  final Project project;

  ProjectContentWrapper({required this.child, required this.project});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [Provider<Project>.value(value: project)],
        child: Expanded(
            child: Scrollbar(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 80),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.query_builder,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _time(context)
                    ],
                  ),
                  Text(Intl.message("Statistics"),
                      style: Theme.of(context).textTheme.headline1),
                  SizedBox(height: 10),
                  child
                ],
              ),
            ),
          ),
        )),
      );

  Widget _time(BuildContext context) => EventListening<ProjectTickEvent>(
        builder: (context, event) {
          if (event == null) {
            return Text(
              "--:--:--",
              style: Theme.of(context).textTheme.headline1,
            );
          }

          return Text(
            "${_timeString(event.eepTimeHour)}:${_timeString(event.eepTimeMinute)}:${_timeString(event.eepTimeSecond)}",
            style: Theme.of(context).textTheme.headline1,
          );
        },
        stream: project.stream,
      );

  String _timeString(Object v) => v.toString().padLeft(2, '0');
}
