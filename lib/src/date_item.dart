import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';

class DateItem extends StatefulWidget {
  /// Date
  final DateTime today;

  /// Date
  final DateTime date;

  /// [TextStyle] of day
  final TextStyle dateStyle;

  /// [TextStyle] of day after pressed
  final TextStyle pressedDateStyle;

  /// [Background] of day
  final Color backgroundColor;

  /// [Background] of today
  final Color todayBackgroundColor;

  /// [Background] of day after pressed

  final Color pressedBackgroundColor;

  /// [Alignment] of decoration
  final Alignment decorationAlignment;

  /// [ShapeBorder] of day
  final ShapeBorder dayShapeBorder;

  /// [Callback] function after pressed on date
  final void Function(DateTime) onDatePressed;

  /// [Callback] function after long pressed on date
  final void Function(DateTime) onDateLongPressed;

  /// Decoration [Widget]
  final Widget decoration;

  /// [BehaviorSubject] emit, listen last date pressed
  final BehaviorSubject<DateTime> subject;

  DateItem({
    @required this.today,
    @required this.date,
    @required this.subject,
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
  /// Default [Background] of day
  Color _defaultBackgroundColor;

  /// Default [TextStyle] of day
  TextStyle _defaultTextStyle;

  @override
  Widget build(BuildContext context) => widget.date != null
      ? StreamBuilder(
          stream: widget.subject,
          builder: (_, data) {
            /// Set default [Background] of day
            _defaultBackgroundColor = widget.backgroundColor;

            /// Set default [TextStyle] of day
            _defaultTextStyle = widget.dateStyle;

            /// If today, set [Background] of today
            if (compareDate(widget.date, widget.today)) {
              _defaultBackgroundColor = widget.todayBackgroundColor;
            } else if (data != null && !data.hasError && data.hasData) {
              final DateTime dateSelected = data.data;
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
          child: FlatButton(
              padding: EdgeInsets.all(5),
              onPressed: _onPressed,
              color: _defaultBackgroundColor,
              shape: widget.dayShapeBorder,
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
                        '${widget.date.day}',
                        style: _defaultTextStyle,
                      ),
                    ),
                  ),
                  _decoration()
                ],
              )),
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
                    child: widget.decoration,
                  )
                : Container()),
      );

  /// Handler pressed
  void _onPressed() {
    widget.subject.add(widget.date);
    widget.onDatePressed(widget.date);
  }

  /// Handler long pressed
  void _onLongPressed() {
    widget.subject.add(widget.date);
    widget.onDateLongPressed(widget.date);
  }
}
