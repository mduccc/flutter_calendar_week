- The sample application was not working. updated.

- Response screen was giving an overflow error on the screen. Fixed.

```dart
  /// [BoxDecoration] of day of week [Container]
  final BoxDecoration? dayOfWeekDecoration;

  /// [BoxDecoration] of calender [Container]
  final BoxDecoration? calenderDecoration;

  /// [BoxDecoration] of day [Container]
  final BoxDecoration? dayDecoration;

  /// [double] width  of day [Container]
  /// if null, it will be [Expanded]
  final double? dayWidth;

  /// [double] height  of day [Container]
  /// if null, it will be [Expanded]
  final double? dayHeight;

  /// [double] height  of day of week [Container]
  /// if null, it will be [Expanded]
  final double? dayOfWeekHeight;

  /// [double] width  of day [Container]
  /// if null, it will be [Expanded]
  final double? dayOfWeekWidth;

```

The above parameters have been added.

`calenderDecoration` BoxDecoration of calender Container

`dayOfWeekDecoration` BoxDecoration of day of week Container

`dayDecoration` BoxDecoration of day Container

`dayWidth` width of day Container

`dayHeight` height of day Container

`dayOfWeekWidth` width of day of week Container

`dayOfWeekHeight` height of day of week Container

> Wraps with expanded if these two parameters are null. `width != null || height != null`

See `item_container.dart` file for details

```dart
  @override
  Widget build(BuildContext context) => width != null || height != null
      ? Container(
          margin: margin,
          width: width,
          height: height,
          decoration: decoration,
          alignment: alignment,
          child: child,
        )
      : Expanded(
          child: (decoration != null || alignment != null)
              ? Container(
                  margin: margin,
                  decoration: decoration,
                  alignment: alignment ?? Alignment.center,
                  child: child,
                )
              : Container(child: child),
        );

```
