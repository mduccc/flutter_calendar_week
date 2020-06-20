// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_calendar_week/model/decoration_item.dart';
import 'package:dartz/dartz.dart' as dartz;

part 'model/week_item.dart';

part 'utils/split_to_week.dart';

part 'utils/compare_date.dart';

part 'date_item.dart';

part 'common.dart';

// ignore: must_be_immutable
class CalendarWeek extends StatefulWidget {
  /* Calendar start from `minDate` */
  final DateTime minDate;

  /* Calendar end at `maxDate` */
  final DateTime maxDate;

  /* TextStyle of day of week */
  TextStyle dayOfWeekStyle;

  /* TextStyle of weekends days */
  TextStyle weekendsStyle;

  /* Alignment of day day of week */
  final FractionalOffset dayOfWeekAlignment;

  /* TextStyle of date */
  TextStyle dateStyle;

  /* Alignment of date */
  final FractionalOffset dateAlignment;

  /* TextStyle of today */
  TextStyle todayDateStyle;

  /* Background of today */
  final Color todayBackgroundColor;

  /* Background of date after pressed */
  final Color pressedDateBackgroundColor;

  /* TextStyle of date after pressed */
  TextStyle pressedDateStyle;

  /* Background of date */
  final Color dateBackgroundColor;

  /* Callback function after pressed on date */
  final void Function(DateTime) onDatePressed;

  /* Callback function after long pressed on date */
  final void Function(DateTime) onDateLongPressed;

  /* Background color of calendar */
  final Color backgroundColor;

  /* List contain titles day of week */
  List<String> dayOfWeek;

  /* List contain indexes of weekends from days titles list */
  List<int> weekendsIndexes;

  /* Vertical space between day of week and date */
  final double spaceBetweenLabelAndDate;

  /* Shape of day */
  final ShapeBorder dayShapeBorder;

  /* List of decorations */
  final List<DecorationItem> decorations;

  /* Height of calendar */
  double height;

  CalendarWeek(
      {@required this.maxDate,
      @required this.minDate,
      this.height = 80,
      this.dayOfWeekStyle =
          const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
      this.dayOfWeekAlignment = FractionalOffset.bottomCenter,
      this.dateStyle =
          const TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
      this.dateAlignment = FractionalOffset.topCenter,
      this.todayDateStyle =
          const TextStyle(color: Colors.orange, fontWeight: FontWeight.w400),
      this.todayBackgroundColor = Colors.black12,
      this.pressedDateBackgroundColor = Colors.blue,
      this.pressedDateStyle =
          const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      this.dateBackgroundColor = Colors.transparent,
      this.onDatePressed,
      this.onDateLongPressed,
      this.backgroundColor = Colors.white,
      this.dayOfWeek = _dayOfWeekDefault,
      this.weekendsIndexes = _weekendsIndexes,
      this.weekendsStyle =
          const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      this.spaceBetweenLabelAndDate = 0,
      this.dayShapeBorder = const CircleBorder(),
      this.decorations = const []}) {
    /* Fit day of week */
    if (dayOfWeek.length < 7) {
      dayOfWeek = _dayOfWeekDefault;
    }
  }

  @override
  _CalendarWeekState createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {
  /* List contain weeks */
  final List<_WeekItem> weeks = [];

  /* default init page */
  int initialPage = 0;

  /* Page controller */
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    /*  Read from minDate to madDate and split to weeks */
    final toWeek =
        _splitToWeek(widget.minDate, widget.maxDate, widget.dayOfWeek);
    weeks.addAll(toWeek.value1);

    /*
      Init Page controller, toWeek.value2 is index of Page contain today.
      Set initialPage is page contain today
    */
    _pageController = PageController(initialPage: toWeek.value2);
  }

  @override
  Widget build(BuildContext context) {
    /* Check range of dates */
    if (widget.minDate.compareTo(widget.maxDate) >= 0) {
      return Text('minDate much before maxDate,'
          ' please fix it before show the CalendarWeek');
    }

    return _root();
  }

  /* Root layout */
  Widget _root() => Container(
      color: widget.backgroundColor,
      width: double.infinity,
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: weeks.length,
        itemBuilder: (_, i) => _week(weeks[i]),
      ));

  // Layout of week
  Widget _week(_WeekItem weeks) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /* Day of week layout */
          Expanded(
            flex: 5,
            child: Align(
              alignment: widget.dayOfWeekAlignment,
              child: _dayOfWeek(weeks.dayOfWeek),
            ),
          ),
          /* Vertical space between day of week and date */
          SizedBox(
            height: widget.spaceBetweenLabelAndDate,
          ),
          /* Date layout */
          Expanded(
            flex: 10,
            child: Align(
              alignment: widget.dateAlignment,
              child: _dates(weeks.days),
            ),
          )
        ],
      );

  /* Day of week layout */
  Widget _dayOfWeek(List<String> dayOfWeek) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dayOfWeek.map((value) => _dayOfWeekItem(value)).toList());

  /* Day of week item layout */
  Widget _dayOfWeekItem(String title) => Container(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 50,
          child: Text(
            title,
            style:  widget.weekendsIndexes.indexOf(widget.dayOfWeek.indexOf(title)) != -1
                ? widget.weekendsStyle
                : widget.dayOfWeekStyle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ));

  /* Date layout */
  Widget _dates(List<DateTime> dates) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dates.map((date) => _dateItem(date)).toList());

  /* Date item layout */
  Widget _dateItem(DateTime date) => _DateItem(
        date: date,
        dateStyle: _compareDate(date, _today)
            ? widget.todayDateStyle
            : date.weekday == 6 || date.weekday == 7
              ? widget.weekendsStyle
              : widget.dateStyle,
        pressedDateStyle: widget.pressedDateStyle,
        backgroundColor: widget.dateBackgroundColor,
        todayBackgroundColor: widget.todayBackgroundColor,
        pressedBackgroundColor: widget.pressedDateBackgroundColor,
        decorationAlignment: () {
          /* If date is contain in decorations list, use decorations Alignment */
          if (widget.decorations.isNotEmpty) {
            final List<DecorationItem> matchDate = widget.decorations
                .where((ele) => _compareDate(ele.date, date))
                .toList();
            return matchDate.isNotEmpty
                ? matchDate[0].decorationAlignment
                : FractionalOffset.center;
          }
          return FractionalOffset.center;
        }(),
        dayShapeBorder: widget.dayShapeBorder,
        onDatePressed: widget.onDatePressed,
        onDateLongPressed: widget.onDateLongPressed,
        decoration: () {
          /* If date is contain in decorations list, use decorations Widget */
          if (widget.decorations.isNotEmpty) {
            final List<DecorationItem> matchDate = widget.decorations
                .where((ele) => _compareDate(ele.date, date))
                .toList();
            return matchDate.isNotEmpty ? matchDate[0].decoration : null;
          }
          return null;
        }(),
      );
}
