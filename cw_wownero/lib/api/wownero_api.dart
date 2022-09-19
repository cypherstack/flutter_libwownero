import 'dart:ffi';
import 'dart:io';

final DynamicLibrary wowneroApi = Platform.isAndroid || Platform.isLinux
    ? DynamicLibrary.open("libcw_wownero.so")
    : DynamicLibrary.open("cw_wownero.framework/cw_wownero");