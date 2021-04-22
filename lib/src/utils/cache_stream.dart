import 'dart:async';

abstract class BaseCacheStream<T> {
  Stream<T> get stream;
  void add(T args);
  T get lastValue;
  void dispose();
}

class CacheStream<T> implements BaseCacheStream<T> {
  StreamController<T> _streamController = StreamController();
  Stream<T> _stream;
  T _lastValue;

  CacheStream() {
    _stream ??= _streamController.stream.asBroadcastStream();
    _stream.listen((value) {
      if (value != null) {
        _lastValue = value;
      }
    });
  }

  @override
  Stream<T> get stream => _stream;

  @override
  void add(T event) {
    _streamController.add(event);
  }

  @override
  T get lastValue => _lastValue;

  @override
  void dispose() {
    _streamController.close();
  }
}
