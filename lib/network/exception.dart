/// Exception for all errors which can occur during working with the network.
class NetworkException implements Exception {
  /// The description of the exception.
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when an unknown packet is received.
class UnknownPacketException extends NetworkException {
  /// The name of the invalid packet.
  final String packet;

  UnknownPacketException(String message, this.packet) : super(message);

  @override
  String toString() => "${super.toString()}: $packet";
}

/// Exception thrown when a malformed packet is received.
class MalformedPacketException extends NetworkException {
  MalformedPacketException(String message) : super(message);
}

/// Exception thrown when the first packet is not a handshake.
class MissingHandshakeException extends NetworkException {
  MissingHandshakeException(String message) : super(message);
}
