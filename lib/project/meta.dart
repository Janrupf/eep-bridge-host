import 'dart:io';
import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';

typedef T MetaDecoder<T>(Uint8List data);

/// Wrapper for a directory for loading and saving meta files.
class MetaDirectory {
  Directory _baseDir;

  MetaDirectory(this._baseDir);

  /// Saves a protocol [message] to the given [name].
  Future save(String name, GeneratedMessage message) {
    final file = File("${_baseDir.path}/$name.protobuf");
    return file.writeAsBytes(message.writeToBuffer());
  }

  /// Reads a protocol [text] from the given [name].
  Future<T> load<T extends GeneratedMessage>(
      String name, MetaDecoder<T> decoder) async {
    final file = File("${_baseDir.path}/$name.protobuf");
    return decoder(await file.readAsBytes());
  }
}
