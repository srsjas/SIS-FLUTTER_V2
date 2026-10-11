import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Flutter Web has no native SQLite, so use the WebAssembly build.
/// Requires web/sqlite3.wasm and web/sqflite_sw.js
/// (generate with: dart run sqflite_common_ffi_web:setup).
Future<void> initDatabaseFactory() async {
  databaseFactory = databaseFactoryFfiWeb;
}