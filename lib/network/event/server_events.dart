import 'package:eep_bridge_host/network/bridge_client.dart';
import 'package:eep_bridge_host/protogen/network/packets.pb.dart';

/// Base for events sent when a client connects or disconnects.
abstract class ServerEvent {
  BridgeClient client;

  ServerEvent(this.client);
}

/// Event sent when a client connected to the server.
class ClientConnectedEvent extends ServerEvent {
  /// The handshake the client sent.
  final Handshake handshake;

  ClientConnectedEvent(BridgeClient client, this.handshake) : super(client);
}

/// Event sent when a client disconnects from the server.
class ClientDisconnectedEvent extends ServerEvent {
  ClientDisconnectedEvent(BridgeClient client) : super(client);
}
