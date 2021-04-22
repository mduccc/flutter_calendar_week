import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/utils/cache_stream.dart';

class CacheStreamBuilder<T> extends StreamBuilder {
  final T initialData;
  final CacheStream<T> cacheStream;
  final AsyncWidgetBuilder cacheBuilder;

  CacheStreamBuilder(
      {this.cacheStream, this.cacheBuilder, this.initialData, Key key})
      : super(
            key: key,
            initialData: initialData,
            stream: cacheStream.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if ((snapshot.hasError || !snapshot.hasData) &&
                  cacheStream.lastValue != null) {
                return cacheBuilder(
                    context,
                    AsyncSnapshot.withData(
                        ConnectionState.done, cacheStream.lastValue));
              } else {
                return cacheBuilder(context, snapshot);
              }
            });
}
