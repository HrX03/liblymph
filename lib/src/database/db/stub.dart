import 'dart:async';

export 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'io.dart';

typedef AsyncStringCallback = FutureOr<String> Function();
typedef OnPreOpenDatabase = void Function();
