import 'dart:async';
import 'dart:io';

import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/network/bridge_client.dart';
import 'package:eep_bridge_host/network/exception.dart';
import 'package:eep_bridge_host/network/packet_decoder.dart';
import 'package:eep_bridge_host/protogen/network/packets.pb.dart';
import 'package:protobuf/protobuf.dart';

import 'event/server_events.dart';

typedef void AnyConnectedListener();

/// Server which EEP clients connect to.
class BridgeServer {
  ServerSocket? _socket;
  late final StreamController<ServerEvent> _eventStreamController;

  BridgeServer() {
    _eventStreamController = StreamController(
        onListen: _openSocket,
        onPause: () => _closeSocket(false),
        onResume: _openSocket,
        onCancel: () => _closeSocket(true));
  }

  /// Starts the server and binds the socket.
  void _openSocket() {
    ServerSocket.bind(InternetAddress.anyIPv4, 12345).then((socket) {
      _socket = socket;
      _socket!.listen(_onClient);
    });
  }

  /// Called by the socket when a client connects.
  void _onClient(Socket socket) async {
    final decoder = PacketDecoder();
    final packetStream = socket.transform(decoder);
    decoder.handshaked.then(
        (handshake) => _handshakeSucceeded(handshake, packetStream, socket),
        onError: (error) => _handshakeFailed(error, socket));
  }

  /// Called when a handshake succeeded
  void _handshakeSucceeded(Handshake handshake,
      Stream<GeneratedMessage> packetStream, Socket socket) {
    Logger.debug("Handshake received: $handshake");
    _eventStreamController.add(
        ClientConnectedEvent(BridgeClient(packetStream, socket), handshake));
  }

  /// Called when handshaking a client fails.
  void _handshakeFailed(NetworkException error, Socket socket) {
    Logger.warn("Handshake failed", error);
    socket.close();
  }

  /// Schedules the server to close.
  void _closeSocket(bool forever) {
    _socket!.close();

    if (forever) {
      _eventStreamController.close();
    }
  }

  bool get hasListener => _eventStreamController.hasListener;

  /// Retrieves the stream of server events.
  Stream<ServerEvent> get stream => _eventStreamController.stream;
}
