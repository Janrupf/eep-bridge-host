import 'package:eep_bridge_host/project/project.dart';

/// Base for events sent by an opened project.
abstract class ProjectEvent {
  final Project project;

  ProjectEvent(this.project);
}

/// Event sent when the client sent a tick message.
class ProjectTickEvent extends ProjectEvent {
  /// The internal client ticks
  final int eepInternalTicks;

  /// The seconds since the simulation day started
  final int eepTime;

  /// The current simulation hour
  final int eepTimeHour;

  /// The current simulation minute
  final int eepTimeMinute;

  /// The current simulation second
  final int eepTimeSecond;

  ProjectTickEvent(Project project,
      {required this.eepInternalTicks,
      required this.eepTime,
      required this.eepTimeHour,
      required this.eepTimeMinute,
      required this.eepTimeSecond})
      : super(project);
}

/// Determines the state of a project.
enum ProjectControlState {
  /// There is no client connected to the project
  noClient,

  /// The project is currently paused
  paused,

  /// The project is running
  running
}

/// Event sent when the pause state of the project changes.
class ProjectControlStateChangeEvent extends ProjectEvent {
  /// The new state the project is in now.
  final ProjectControlState state;

  ProjectControlStateChangeEvent(Project project, this.state) : super(project);
}
