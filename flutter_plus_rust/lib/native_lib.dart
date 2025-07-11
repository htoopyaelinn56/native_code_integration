import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

typedef AddFfiNative = ffi.Uint64 Function(ffi.Uint64, ffi.Uint64);
typedef AddFfi = int Function(int, int);

typedef GreetFfiNative = ffi.Pointer<ffi.Char> Function();
typedef GreetFfi = ffi.Pointer<ffi.Char> Function();

class NativeLib {
  static late final ffi.DynamicLibrary _lib;
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    if (Platform.isAndroid) {
      _lib = ffi.DynamicLibrary.open('libnative_lib.so');
    } else if (Platform.isIOS) {
      _lib = ffi.DynamicLibrary.process();
    } else {
      throw UnsupportedError('This platform is not supported');
    }
    _initialized = true;
  }

  static int addFfi(int left, int right) {
    final addFfiPtr = _lib.lookup<ffi.NativeFunction<AddFfiNative>>('add_ffi');
    final addFfi = addFfiPtr.asFunction<AddFfi>();
    return addFfi(left, right);
  }

  static String greetFfi() {
    final greetFfiPtr = _lib.lookup<ffi.NativeFunction<GreetFfiNative>>(
      'greet_ffi',
    );
    final greetFfi = greetFfiPtr.asFunction<GreetFfi>();
    final ptr = greetFfi();
    final result = ptr.cast<Utf8>().toDartString();
    calloc.free(ptr);
    return result;
  }
}
