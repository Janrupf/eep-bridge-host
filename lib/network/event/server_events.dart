import 'package:eep_bridge_host/network/bridge_client.dart';

/// Base for events sent when a client connects or disconnects.
abstract class ServerEvent {
  BridgeClient client;

  ServerEvent(this.client);
}

/// Event sent when a client connected to the server.
class ClientConnectedEvent extends ServerEvent {
  ClientConnectedEvent(BridgeClient client) : super(client);
}

/// Event sent when a client disconnects from the server.
class ClientDisconnectedEvent extends ServerEvent {
  ClientDisconnectedEvent(BridgeClient client) : super(client);
}