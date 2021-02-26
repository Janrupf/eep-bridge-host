import 'dart:io';

import 'package:protobuf/protobuf.dart';

/// Represents a simple EEP bridge client.
class BridgeClient {
  final Stream<GeneratedMessage> messageStream;
  final Socket socket;

  BridgeClient(this.messageStream, this.socket);
}