import 'dart:io';

import 'package:eep_bridge_host/network/packet_encoder.dart';
import 'package:eep_bridge_host/protogen/network/packets.pb.dart';
import 'package:protobuf/protobuf.dart';

/// Represents a simple EEP bridge client.
class BridgeClient {
  final Stream<GeneratedMessage> messageStream;
  final PacketEncoder encoder;

  BridgeClient(this.messageStream, Socket socket)
      : encoder = PacketEncoder(socket);

  /// Notifies the client that the handshake succeeded
  Future handshakeSucceeded() {
    return encoder.send(HandshakeResponse(
      success: HandshakeSuccessful(unpause: false)
    ));
  }

  Future handshakeFailed(String reason) async {
    await encoder.send(HandshakeResponse(
      failure: HandshakeFailure(reason: reason)
    ));
    await encoder.socket.close();
  }
}
