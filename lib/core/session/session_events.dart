import 'dart:async';

import 'package:injectable/injectable.dart';

@singleton
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get expired => _expired.stream;

  void notifyExpired() => _expired.add(null);

  @disposeMethod
  Future<void> dispose() => _expired.close();
}
