import 'dart:io';

import 'package:uuid/uuid.dart';

/// Utility extensions on the directory class for performing I/O operations.
extension DirectoryIOExtensions on Directory {
  /// Joins this directory with a [child].
  Directory join(dynamic child) {
    return Directory(
        "$path/${child is FileSystemEntity ? child.path : child.toString()}");
  }

  /// Generates a unique child directory name.
  Future<Directory> availableChild() async {
    Directory child;
    do {
      child = join(Uuid().v4());
    } while (await child.exists());

    return child;
  }
}

/// Utility extensions on the String class for performing I/O operations.
extension StringIOExtensions on String {
  /// Escapes all possibly problematic characters for a file name in this String.
  String escapeAsFileName() {
    return replaceAll("[\\\\/:*?\"<>|]", "_");
  }
}
