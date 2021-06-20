import 'dart:async';

/// [BaseCacheStream] cache last value of Stream
abstract class BaseCacheStream<T> {
  /// Expose a [stream] for external
  Stream<T>? get stream;

  /// Add event to [BaseCacheStream]
  void add(T args);

  /// Last value of [stream]
  T get lastValue;

  /// Close [BaseCacheStream]
  void close();
}

/// [CacheStream] implement [BaseCacheStream]
class CacheStream<T> implements BaseCacheStream<T?> {
  /// [_streamController] for add and listen event
  StreamController<T?> _streamController = StreamController();
  Stream<T?>? _stream;
  T? _lastValue;

  /// init [_stream] and listen for update [_lastValue]
  CacheStream() {
    _stream ??= _streamController.stream.asBroadcastStream();
    _stream!.listen((value) {
      if (value != null) {
        _lastValue = value;
      }
    });
  }

  @override
  Stream<T?>? get stream => _stream;

  @override
  void add(T? event) {
    _streamController.add(event);
  }

  @override
  T? get lastValue => _lastValue;

  @override
  void close() {
    _streamController.close();
  }
}
