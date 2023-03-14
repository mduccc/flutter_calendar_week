import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/cache_stream_widget.dart';
import 'package:flutter_calendar_week/src/utils/cache_stream.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';

class DateItem extends StatefulWidget {
  /// Today
  final DateTime today;

  /// Date of item
  final DateTime? date;

  /// Style of [date]
  final TextStyle? dateStyle;

  /// Style of day after pressed
  final TextStyle? pressedDateStyle;

  /// Background
  final Color? backgroundColor;

  /// Specify a background if [date] is [today]
  final Color? todayBackgroundColor;

  /// Specify a background after pressed
  final Color? pressedBackgroundColor;

  /// Alignment a decoration
  final Alignment? decorationAlignment;

  /// Specify a shape
  final BoxShape? dayShapeBorder;

  /// [Callback] function for press event
  final void Function(DateTime)? onDatePressed;

  /// [Callback] function for long press event
  final void Function(DateTime)? onDateLongPressed;

  /// Decoration widget
  final Widget? decoration;

  /// [cacheStream] for emit date press event
  final CacheStream<DateTime?> cacheStream;

  DateItem({
    required this.today,
    required this.date,
    required this.cacheStream,
    this.dateStyle,
    this.pressedDateStyle,
    this.backgroundColor = Colors.transparent,
    this.todayBackgroundColor = Colors.orangeAccent,
    this.pressedBackgroundColor,
    this.decorationAlignment = FractionalOffset.center,
    this.dayShapeBorder,
    this.onDatePressed,
    this.onDateLongPressed,
    this.decoration,
  });

  @override
  __DateItemState createState() => __DateItemState();
}

class __DateItemState extends State<DateItem> {
  /// Default background
  Color? _defaultBackgroundColor;

  /// Default style
  TextStyle? _defaultTextStyle;

  @override
  Widget build(BuildContext context) => widget.date != null
      ? CacheStreamBuilder<DateTime?>(
          cacheStream: widget.cacheStream,
          cacheBuilder: (_, data) {
            /// Set default each [builder] is called
            _defaultBackgroundColor = widget.backgroundColor;

            /// Set default style each [builder] is called
            _defaultTextStyle = widget.dateStyle;

            /// Check and set [Background] of today
            if (compareDate(widget.date, widget.today)) {
              if (compareDate(widget.date, dateSelected)) {
                _defaultBackgroundColor = widget.pressedBackgroundColor;
                print('temp');
              }
              _defaultBackgroundColor = widget.todayBackgroundColor;
              print('temp2');
            } else if (!data.hasError && data.hasData) {
              
              if (compareDate(widget.date, dateSelected)) {
                _defaultBackgroundColor = widget.pressedBackgroundColor;
                _defaultTextStyle = widget.pressedDateStyle;
              }
            }
            return _body();
          },
        )
      : Container(
          width: 50,
          height: 50,
        );

  /// Body layout
  Widget _body() => Container(
        width: 50,
        height: 50,
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onLongPress: _onLongPressed,
          child: GestureDetector(
            onTap: _onPressed,
            child: Container(
                decoration: BoxDecoration(
                  color: _defaultBackgroundColor!,
                  shape: widget.dayShapeBorder!,
                ),
                padding: EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${widget.date!.day}',
                          style: _defaultTextStyle!,
                        ),
                      ),
                    ),
                    _decoration()
                  ],
                )),
          ),
        ),
      );

  /// Decoration layout
  Widget _decoration() => Positioned(
        top: 28,
        left: 0,
        right: 0,
        child: Container(
            width: 50,
            height: 12,
            alignment: widget.decorationAlignment,
            child: widget.decoration != null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: widget.decoration!,
                  )
                : Container()),
      );

  /// Handler press event
  void _onPressed() {
    if (widget.date != null) {
      widget.cacheStream.add(widget.date);
      widget.onDatePressed!(widget.date!);
    }
  }

  /// Handler long press event
  void _onLongPressed() {
    if (widget.date != null) {
      widget.cacheStream.add(widget.date);
      widget.onDateLongPressed!(widget.date!);
    }
  }
}
