import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';

class DateItem extends StatelessWidget {
  final DateTime today;
  final DateTime? date;
  final TextStyle? dateStyle;
  final TextStyle? pressedDateStyle;
  final Color? backgroundColor;
  final Color? todayBackgroundColor;
  final Color? pressedBackgroundColor;
  final Alignment? decorationAlignment;
  final BoxShape? dayShapeBorder;
  final void Function(DateTime)? onDatePressed;
  final void Function(DateTime)? onDateLongPressed;
  final Widget? decoration;
  final ValueNotifier<DateTime?> selectedDateNotifier;

  const DateItem({
    required this.today,
    required this.date,
    required this.selectedDateNotifier,
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
  Widget build(BuildContext context) => date != null
      ? ValueListenableBuilder<DateTime?>(
          valueListenable: selectedDateNotifier,
          builder: (_, selectedDate, __) => _body(selectedDate),
        )
      : const SizedBox(width: 50, height: 50);

  Widget _body(DateTime? selectedDate) {
    Color? bgColor = backgroundColor;
    TextStyle? textStyle = dateStyle;

    if (compareDate(date, today)) {
      bgColor = todayBackgroundColor;
    } else if (compareDate(date, selectedDate)) {
      bgColor = pressedBackgroundColor;
      textStyle = pressedDateStyle;
    }

    return Container(
      width: 50,
      height: 50,
      alignment: FractionalOffset.center,
      child: GestureDetector(
        onLongPress: _onLongPressed,
        child: GestureDetector(
          onTap: _onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor!,
              shape: dayShapeBorder!,
            ),
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(child: Text('${date!.day}', style: textStyle!)),
                ),
                _decoration(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _decoration() => Align(
        alignment: decorationAlignment!,
        child: decoration ?? const SizedBox.shrink(),
      );

  void _onPressed() {
    if (date != null) {
      selectedDateNotifier.value = date;
      onDatePressed?.call(date!);
    }
  }

  void _onLongPressed() {
    if (date != null) {
      selectedDateNotifier.value = date;
      onDateLongPressed?.call(date!);
    }
  }
}
