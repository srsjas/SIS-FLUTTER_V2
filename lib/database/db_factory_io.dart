import 'dart:io' show Platform;

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Android and iOS use the regular sqflite plugin as-is.
/// Desktop platforms need the FFI implementation.
Future<void> initDatabaseFactory() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}