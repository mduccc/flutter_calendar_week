part of 'calendar_week.dart';

// ignore: must_be_immutable
class _DateItem extends StatelessWidget {
  /* Day */
  final DateTime date;

  /* TextStyle of day */
  final TextStyle dateStyle;

  /* TextStyle of day after pressed */
  TextStyle pressedDateStyle;

  /* Background of day */
  final Color backgroundColor;

  /* Background of today */
  final Color todayBackgroundColor;

  /* Background of day after pressed */

  final Color pressedBackgroundColor;

  /* Alignment of decoration */
  final Alignment decorationAlignment;

  /* Shape of day */
  final ShapeBorder dayShapeBorder;

  /* Callback function after pressed on date */
  final void Function(DateTime) onDatePressed;

  /* Callback function after long pressed on date */
  final void Function(DateTime) onDateLongPressed;

  /* Decoration Widget */
  Widget decoration;

  /* Default background of day */
  Color _defaultBackgroundColor;

  /* Default TextStyle of day */
  TextStyle _defaultTextStyle;

  _DateItem({
    this.date,
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
  Widget build(BuildContext context) {
    return date != null
        ? StreamBuilder(
            stream: _dateSubject,
            builder: (_, data) {
              /* Set default background of day */
              _defaultBackgroundColor = backgroundColor;
              /* Set default TextStyle of day */
              _defaultTextStyle = dateStyle;
              /* If today, set background of today */
              if (_compareDate(date, _today)) {
                _defaultBackgroundColor = todayBackgroundColor;
              } else if (data != null && !data.hasError && data.hasData) {
                final DateTime dateSelected = data.data;
                if (_compareDate(date, dateSelected)) {
                  _defaultBackgroundColor = pressedBackgroundColor;
                  _defaultTextStyle = pressedDateStyle;
                }
              }

              return _root();
            },
          )
        : Container();
  }

  /* Root layout */
  Widget _root() => Container(
        width: 50,
        height: 50,
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onLongPress: _onLongPressed,
          child: FlatButton(
              padding: EdgeInsets.all(5),
              onPressed: _onPressed,
              color: _defaultBackgroundColor,
              shape: dayShapeBorder,
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
                        '${date.day}',
                        style: _defaultTextStyle,
                      ),
                    ),
                  ),
                  _decoration()
                ],
              )),
        ),
      );

  /* Decoration layout */
  Widget _decoration() => Positioned(
        top: 28,
        left: 0,
        right: 0,
        child: Container(
            width: 50,
            height: 12,
            alignment: decorationAlignment,
            child: decoration != null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: decoration,
                  )
                : Container()),
      );

  /* Handler pressed */
  void _onPressed() {
    _dateSubject.add(date);
    onDatePressed(date);
  }

  /* Handler long pressed */
  void _onLongPressed() {
    _dateSubject.add(date);
    onDateLongPressed(date);
  }
}
