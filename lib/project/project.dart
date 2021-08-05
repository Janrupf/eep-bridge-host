import 'dart:async';

import 'package:eep_bridge_host/network/bridge_client.dart';
import 'package:eep_bridge_host/project/event/project_events.dart';
import 'package:eep_bridge_host/project/layout.dart';
import 'package:eep_bridge_host/protogen/network/packets.pb.dart';
import 'package:eep_bridge_host/protogen/project/project.pb.dart';
import 'package:protobuf/protobuf.dart';

/// Representation of an opened project.
class Project {
  /// Metadata of the project
  final ProjectMeta meta;

  final StreamController<ProjectEvent> _eventController;

  /// Current client, if any
  BridgeClient? _client;

  bool _paused;

  /// Current subscription to an event stream, if any
  StreamSubscription<GeneratedMessage>? _currentSubscription;

  late final Layout layout;

  Project({required this.meta})
      : _eventController = StreamController.broadcast(),
        _client = null,
        _currentSubscription = null,
        _paused = true {
    this.layout = Layout(meta.layout);
  }

  /// Called when a client controlling this project has connected.
  void clientConnected(BridgeClient client) {
    if (_currentSubscription != null) {
      _currentSubscription!.cancel();
    }

    _client = client;
    _client!.messageStream.listen(_onMessage);
    requestControlStateEvent();
  }

  /// Called when the client has disconnected.
  void clientDisconnected() {
    if (_currentSubscription != null) {
      _currentSubscription!.cancel();
    }

    _client = null;
    requestControlStateEvent();
  }

  /// Determines whether this project is controlled by a certain [client].
  bool controlledBy(BridgeClient client) => _client == client;

  /// Called when a message from the currently controlling client is received
  void _onMessage(GeneratedMessage message) {
    if (message is Heartbeat) {
      _eventController.add(ProjectTickEvent(this,
          eepInternalTicks: message.internalTicks.toInt(),
          eepTime: message.eepTime,
          eepTimeHour: message.eepTimeHour,
          eepTimeMinute: message.eepTimeMinute,
          eepTimeSecond: message.eepTimeSecond));
    }
  }

  set paused(bool value) {
    if (_paused == value) {
      return;
    }

    _paused = value;
    _client!.send(SetPauseState(pause: value));
    requestControlStateEvent();
  }

  void requestControlStateEvent() {
    if (_client == null) {
      _eventController.add(
          ProjectControlStateChangeEvent(this, ProjectControlState.noClient));
    } else {
      _eventController.add(ProjectControlStateChangeEvent(this,
          _paused ? ProjectControlState.paused : ProjectControlState.running));
    }
  }

  void setSignal(int signal, int state) {
    _client!.send(SetControlObject(
      type: ObjectType.SIGNAL,
      objectId: signal,
      state: state,
    ));
  }

  void setSwitch(int sw, int state) {
    _client!.send(SetControlObject(
      type: ObjectType.SWITCH,
      objectId: sw,
      state: state,
    ));
  }

  bool get paused => _paused;

  /// Stream on which project events are dispatched
  Stream<ProjectEvent> get stream => _eventController.stream;
}
