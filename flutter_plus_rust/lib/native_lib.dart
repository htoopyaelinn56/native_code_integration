import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

typedef AddFfiNative = ffi.Uint64 Function(ffi.Uint64, ffi.Uint64);
typedef AddFfi = int Function(int, int);

typedef GreetFfiNative = ffi.Pointer<ffi.Char> Function();
typedef GreetFfi = ffi.Pointer<ffi.Char> Function();

typedef GetRandomFfiNative = ffi.Pointer<ffi.Char> Function();
typedef GetRandomFfi = ffi.Pointer<ffi.Char> Function();

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

  static Future<String> getRandomFfi() async {
    // since get_random_ffi exposed from c lib is synchronous and blocking,
    // will use compute not to block the UI thread.
    final result = await compute<Null, String>((message) {
      init();
      final getRandomFfiPtr = _lib
          .lookup<ffi.NativeFunction<GetRandomFfiNative>>('get_random_ffi');
      final getRandomFfi = getRandomFfiPtr.asFunction<GetRandomFfi>();
      final ptr = getRandomFfi();
      final result = ptr.cast<Utf8>().toDartString();
      calloc.free(ptr);
      return result;
    }, null);
    return result;
  }
}
