import 'dart:io';
import 'dart:typed_data';

import 'package:eep_bridge_host/protogen/network/packets.pb.dart';
import 'package:protobuf/protobuf.dart';

/// All known names for top level messages.
const Map<Type, String> _decoders = {HandshakeResponse: "HandshakeResponse"};

class PacketEncoder {
  final Socket socket;

  PacketEncoder(this.socket);

  /// Sends a [message] of a specific type [T] using the underlying socket.
  Future send<T extends GeneratedMessage>(T message) async {
    final name = _decoders[T];

    if (name == null) {
      throw ArgumentError("No message name for $message");
    }

    // Encode the message into a buffer so we can get the length
    final messageData = message.writeToBuffer();

    // Entire length (
    //    uint8{name length} +
    //    bytes[name.length]{name} +
    //    uint16{message length} +
    //    bytes[message.length]{message}
    // )
    final bufferSize = 1 + name.length + 2 + messageData.lengthInBytes;
    var writeHead = 0; // Used to keep track of where we are writing

    // Create a packet buffer
    final packetData = ByteData(bufferSize);

    // 1. Write name length
    packetData.setUint8(0, name.length);
    writeHead++;

    // 2. Copy name into buffer
    for (int i = 0; i < name.length; i++) {
      final c = name.codeUnitAt(i);
      assert(c <= 255);

      packetData.setUint8(writeHead++, c);
    }

    // 3. Write message length
    packetData.setUint16(writeHead, messageData.length);
    writeHead += 2;

    // 4. Copy message into buffer
    for (int i = 0; i < messageData.length; i++) {
      packetData.setUint8(writeHead++, messageData[i]);
    }

    // 5. Finalize buffer and send it
    final generated = packetData.buffer.asUint8List();
    socket.add(generated);

    // 6. Make sure the data has been processed by dart
    //   (this does not ensure that the operating system processed the data!)
    await socket.flush();
  }
}
