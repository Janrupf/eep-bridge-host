import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:eep_bridge_host/network/exception.dart';
import 'package:eep_bridge_host/network/protocol/packets.pb.dart';
import 'package:protobuf/protobuf.dart';

enum _ReadState { nameLength, name, packetLength, packet }

/// Function type for decoding a packet from a buffer.
typedef GeneratedMessage _PacketFromBuffer(List<int> buffer);

/// All known decoders for top level messages.
Map<String, _PacketFromBuffer> _decoders = {
  "Handshake": (buffer) => Handshake.fromBuffer(buffer),
  "Heartbeat": (buffer) => Heartbeat.fromBuffer(buffer)
};

/// Stream transformer for transforming a data stream to protobuf messages.
class PacketDecoder extends StreamTransformerBase<Uint8List, GeneratedMessage> {
  _ReadState _state = _ReadState.nameLength;

  int _remaining = 0;
  List<int> _buffer = [];

  String? _name = "";

  // ignore: close_sinks
  StreamController<GeneratedMessage> _controller = StreamController();

  @override
  Stream<GeneratedMessage> bind(Stream<Uint8List> stream) {
    stream.listen(_onData,
        cancelOnError: true,
        onDone: _controller.close,
        onError: _controller.addError);
    return _controller.stream;
  }

  /// Function called when data is available on the socket.
  void _onData(List<int> data) {
    _buffer.addAll(data);
    _process();
  }

  List<int> _readBuffer(int n) {
    final data = _buffer.sublist(0, n);
    _buffer.removeRange(0, n);
    return data;
  }

  /// Runs a loop processing all data buffered until that is not possible anymore.
  void _process() {
    while (_buffer.isNotEmpty) {
      switch (_state) {
        case _ReadState.nameLength:
          {
            // Packet name length is represented as a single unsigned char
            // in native code
            _remaining = Uint8List.fromList(_readBuffer(1))[0];
            _state = _ReadState.name;
            break;
          }

        case _ReadState.name:
          {
            if (_buffer.length < _remaining) {
              return;
            }

            // Decode the name as UTF8 from the buffer
            _name = utf8.decode(_readBuffer(_remaining));
            _remaining = 0;
            _state = _ReadState.packetLength;
            break;
          }

        case _ReadState.packetLength:
          {
            if (_buffer.length < 2) {
              return;
            }

            // The packet length is represented as a single uint16_t in the
            // native code
            _remaining = Uint16List.fromList(_readBuffer(2))[0];
            _state = _ReadState.packet;
            break;
          }

        case _ReadState.packet:
          {
            if (_buffer.length < _remaining) {
              return;
            }

            // Get a matching decoder for the packet name
            final decoder = _decoders[_name];
            if (decoder == null) {
              _controller.addError(UnknownPacketException(
                  "An unknown packet name has been received", _name!));
            } else {
              // Decode the packet by reading the remaining data
              _controller.add(decoder(_readBuffer(_remaining)));
            }

            _state = _ReadState.nameLength;
            _remaining = 0;
            _name = null;

            break;
          }
      }
    }
  }
}
