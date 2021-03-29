import 'dart:io';

import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/network/bridge_server.dart';
import 'package:eep_bridge_host/network/packet_encoder.dart';
import 'package:eep_bridge_host/protogen/network/packets.pb.dart';
import 'package:protobuf/protobuf.dart';

/// Represents a simple EEP bridge client.
class BridgeClient {
  final Stream<GeneratedMessage> messageStream;
  final DisconnectingCallback disconnectingCallback;
  final PacketEncoder _encoder;

  BridgeClient(this.messageStream, this.disconnectingCallback, Socket socket)
      : _encoder = PacketEncoder(socket);

  /// Notifies the client that the handshake succeeded
  Future handshakeSucceeded() {
    return _encoder.send(HandshakeResponse(success: HandshakeSuccessful()));
  }

  Future handshakeFailed(String reason) async {
    await _encoder
        .send(HandshakeResponse(failure: HandshakeFailure(reason: reason)));
    await _encoder.socket.close();
  }

  void send<T extends GeneratedMessage>(T message) {
    _encoder.send(message).onError((error, stackTrace) {
      Logger.error("Failed to send message to client, closing connection!",
          error, stackTrace);
      try {
        _encoder.socket.close().catchError((error, stackTrace) =>
            Logger.verbose(
                "Failed to close socket in future after connection error",
                error,
                stackTrace));
      } catch (error, stackTrace) {
        Logger.verbose(
            "Failed to close socket after connection error", error, stackTrace);
      }

      disconnectingCallback(this, error, stackTrace);
    });
  }
}
