
// Picks the right SQLite backend for the current platform.
//  - Web (Chrome):            sqflite_common_ffi_web (WebAssembly SQLite)
//  - Windows / Linux / macOS: sqflite_common_ffi
//  - Android / iOS:           default sqflite plugin (nothing to set up)
export 'db_factory_stub.dart'
    if (dart.library.js_interop) 'db_factory_web.dart'
    if (dart.library.io) 'db_factory_io.dart';