import 'package:protobuf/protobuf.dart';

/// Represents a simple EEP bridge client.
class BridgeClient {
  final Stream<GeneratedMessage> _messageStream;

  BridgeClient(this._messageStream);
}