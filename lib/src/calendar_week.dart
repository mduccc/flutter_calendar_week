import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/models/decoration_item.dart';
import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/date_item.dart';
import 'package:flutter_calendar_week/src/utils/find_current_week_index.dart';
import 'package:flutter_calendar_week/src/utils/separate_weeks.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';

import 'package:flutter_calendar_week/src/strings.dart';
import 'package:flutter_calendar_week/src/utils/cache_stream.dart';

class CalendarWeekController {
/*
Example:
  CalendarWeek(
                controller: CalendarWeekController(),
                height: 100,
                showMonth: true,
                minDate: DateTime.now().add(
                  Duration(days: -365),
                ),
                maxDate: DateTime.now().add(
                  Duration(days: 365),
                ),
                
                onDatePressed: (DateTime datetime) {
                  // Do something
                },
                onDateLongPressed: (DateTime datetime) {
                // Do something
                },
                onWeekChanged: () {
                  // Do something
                },
                decorations: [
                  DecorationItem(
                      decorationAlignment: FractionalOffset.bottomRight,
                      date: DateTime.now(),
                      decoration: Icon(
                        Icons.today,
                        color: Colors.blue,
                      )),
                  DecorationItem(
                      date: DateTime.now().add(Duration(days: 3)),
                      decoration: Text(
                        'Holiday',
                        style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              )
*/

  /// Today date time
  DateTime _today = DateTime.now();

  /// Store hast attach to a client state
  bool _hasClient = false;

  /// Return [true] if attached to [CalendarWeek] widget
  bool get hasClient => _hasClient;

  /// Store a selected date
  DateTime? _selectedDate;

  /// Get [_selectedDate] selected;
  DateTime get selectedDate => _selectedDate ?? _today;

  /// get [_weeks]
  List<DateTime?> get rangeWeekDate => _weeks.isNotEmpty
      ? _weeks[_currentWeekIndex].days.where((ele) => ele != null).toList()
      : [];

  /// [Callback] for update widget event
  late Function(DateTime?) _widgetJumpToDate;

  /// Index of week display on the screen
  int _currentWeekIndex = 0;

  /// Store a list [DateTime] of weeks display on the screen
  final List<WeekItem> _weeks = [];

  /// [jumpToDate] show week contain [date] on the screen
  void jumpToDate(DateTime date) {
    /// Find [_newCurrentWeekIndex] corresponding new [dateTime]
    final _newCurrentWeekIndex = findCurrentWeekIndexByDate(date, _weeks);

    /// If has matched, update [_currentWeekIndex], [_selectedDate]
    /// and call [_widgetJumpToDate] for update widget
    if (_newCurrentWeekIndex != -1) {
      _currentWeekIndex = _newCurrentWeekIndex;

      _selectedDate = date;

      /// Call [_widgetJumpToDate] for update Widget
      _widgetJumpToDate(_selectedDate);
    }
  }
}

class CalendarWeek extends StatefulWidget {
  /// Calendar start from [minDate]
  final DateTime minDate;

  /// Calendar end at [maxDate]
  final DateTime maxDate;

  /// Style of months
  final TextStyle monthStyle;

  /// Style of day of week
  final TextStyle dayOfWeekStyle;

  /// Style of weekends days
  final TextStyle weekendsStyle;

  /// Alignment of day day of week
  final FractionalOffset monthAlignment;

  /// Style of dates
  final TextStyle dateStyle;

  /// Specify a style for today
  final TextStyle todayDateStyle;

  /// Specify a background for today
  final Color todayBackgroundColor;

  /// Specify background for date after pressed
  final Color datePressedBackgroundColor;

  /// Specify a style for date after pressed
  final TextStyle datePressedStyle;

  /// Background for dates
  final Color dateBackgroundColor;

  /// [Callback] function for press event
  final void Function(DateTime) onDatePressed;

  /// [Callback] function for long press even
  final void Function(DateTime) onDateLongPressed;

  /// Background color of calendar
  final Color backgroundColor;

  /// List contain titles day of week
  final List<String> daysOfWeek;

  /// List contain title months
  final List<String> months;

  /// Condition show month
  final bool monthDisplay;

  /// List contain indexes of weekends from days titles list
  final List<int> weekendsIndexes;

  /// Margin day of week row
  final EdgeInsets marginDayOfWeek;

  /// Margin month row
  final EdgeInsets marginMonth;

  /// Shape of day
  final ShapeBorder dayShapeBorder;

  /// List of decorations
  final List<DecorationItem> decorations;

  /// Height of calendar
  final double height;

  /// Page controller
  final CalendarWeekController? controller;

  /// [Callback] changed week event
  final Function() onWeekChanged;

  CalendarWeek._(
      Key? key,
      this.maxDate,
      this.minDate,
      this.height,
      this.monthStyle,
      this.dayOfWeekStyle,
      this.monthAlignment,
      this.dateStyle,
      this.todayDateStyle,
      this.todayBackgroundColor,
      this.datePressedBackgroundColor,
      this.datePressedStyle,
      this.dateBackgroundColor,
      this.onDatePressed,
      this.onDateLongPressed,
      this.backgroundColor,
      this.daysOfWeek,
      this.months,
      this.monthDisplay,
      this.weekendsIndexes,
      this.weekendsStyle,
      this.marginMonth,
      this.marginDayOfWeek,
      this.dayShapeBorder,
      this.decorations,
      this.controller,
      this.onWeekChanged)
      : assert(daysOfWeek.length == 7),
        assert(months.length == 12),
        assert(minDate.isBefore(maxDate)),
        super(key: key);

  factory CalendarWeek(
          {Key? key,
          DateTime? maxDate,
          DateTime? minDate,
          double height = 100,
          TextStyle monthStyle =
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          TextStyle dayOfWeekStyle =
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          FractionalOffset monthAlignment = FractionalOffset.center,
          TextStyle dateStyle =
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
          TextStyle todayDateStyle = const TextStyle(
              color: Colors.orange, fontWeight: FontWeight.w400),
          Color todayBackgroundColor = Colors.black12,
          Color pressedDateBackgroundColor = Colors.blue,
          TextStyle pressedDateStyle =
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          Color dateBackgroundColor = Colors.transparent,
          Function(DateTime)? onDatePressed,
          Function(DateTime)? onDateLongPressed,
          Color backgroundColor = Colors.white,
          List<String> dayOfWeek = dayOfWeekDefault,
          List<String> month = monthDefaults,
          bool showMonth = true,
          List<int> weekendsIndexes = weekendsIndexesDefault,
          TextStyle weekendsStyle =
              const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          EdgeInsets marginMonth = const EdgeInsets.symmetric(vertical: 4),
          EdgeInsets marginDayOfWeek = const EdgeInsets.symmetric(vertical: 4),
          CircleBorder dayShapeBorder = const CircleBorder(),
          List<DecorationItem> decorations = const [],
          CalendarWeekController? controller,
          Function()? onWeekChanged}) =>
      CalendarWeek._(
          key,
          maxDate ?? DateTime.now().add(Duration(days: 180)),
          minDate ?? DateTime.now().add(Duration(days: -180)),
          height,
          monthStyle,
          dayOfWeekStyle,
          monthAlignment,
          dateStyle,
          todayDateStyle,
          todayBackgroundColor,
          pressedDateBackgroundColor,
          pressedDateStyle,
          dateBackgroundColor,
          onDatePressed ?? (DateTime date) {},
          onDateLongPressed ?? (DateTime date) {},
          backgroundColor,
          dayOfWeek,
          month,
          showMonth,
          weekendsIndexes,
          weekendsStyle,
          marginMonth,
          marginDayOfWeek,
          dayShapeBorder,
          decorations,
          controller,
          onWeekChanged ?? () {});

  @override
  _CalendarWeekState createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {
  /// [_streamController] for emit date press event
  final CacheStream<DateTime?> _cacheStream = CacheStream<DateTime?>();

  /// [_stream] for listen date change event
  Stream<DateTime?>? _stream;

  /// Page controller
  late PageController _pageController;

  CalendarWeekController _defaultCalendarController = CalendarWeekController();

  CalendarWeekController get controller =>
      widget.controller ?? _defaultCalendarController;

  void _jumToDateHandler(DateTime? dateTime) {
    _cacheStream.add(dateTime);
    _pageController.animateToPage(widget.controller!._currentWeekIndex,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _setUp() {
    assert(controller.hasClient == false);
    _stream ??= _cacheStream.stream!.asBroadcastStream();
    controller
      .._weeks.clear()
      .._weeks.addAll(separateWeeks(
          widget.minDate, widget.maxDate, widget.daysOfWeek, widget.months))

      /// [_currentWeekIndex] is index of week in [List] weeks contain today

      .._currentWeekIndex =
          findCurrentWeekIndexByDate(controller._today, controller._weeks)
      .._widgetJumpToDate = _jumToDateHandler
      .._hasClient = true;

    /// Init Page controller
    /// Set [initialPage] is page contain today
    _pageController = PageController(initialPage: controller._currentWeekIndex);
  }

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  Widget build(BuildContext context) => _body();

  /// Body layout
  Widget _body() => Container(
      color: widget.backgroundColor,
      width: double.infinity,
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: controller._weeks.length,
        onPageChanged: (currentPage) {
          widget.controller!._currentWeekIndex = currentPage;
          widget.onWeekChanged();
        },
        itemBuilder: (_, i) => _week(controller._weeks[i]),
      ));

  /// Layout of week
  Widget _week(WeekItem weeks) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Month
          widget.monthDisplay ? _monthItem(weeks.month) : Container(),

          /// Day of week layout
          _dayOfWeek(weeks.dayOfWeek),

          /// Date layout
          _dates(weeks.days)
        ],
      );

  /// Day of week item layout
  Widget _monthItem(String title) => Align(
        alignment: widget.monthAlignment,
        child: Container(
            margin: widget.marginMonth,
            child: Text(
              title,
              style: widget.monthStyle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )),
      );

  /// Day of week layout
  Widget _dayOfWeek(List<String> dayOfWeek) => Container(
        margin: widget.marginDayOfWeek,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayOfWeek.map(_dayOfWeekItem).toList()),
      );

  /// Day of week item layout
  Widget _dayOfWeekItem(String title) => Container(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 50,
          child: Text(
            title,
            style: widget.weekendsIndexes
                        .indexOf(widget.daysOfWeek.indexOf(title)) !=
                    -1
                ? widget.weekendsStyle
                : widget.dayOfWeekStyle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ));

  /// Date layout
  Widget _dates(List<DateTime?> dates) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dates.map(_dateItem).toList());

  /// Date item layout
  Widget _dateItem(DateTime? date) => DateItem(
      today: controller._today,
      date: date,
      dateStyle: compareDate(date, controller._today)
          ? widget.todayDateStyle
          : date != null && (date.weekday == 6 || date.weekday == 7)
              ? widget.weekendsStyle
              : widget.dateStyle,
      pressedDateStyle: widget.datePressedStyle,
      backgroundColor: widget.dateBackgroundColor,
      todayBackgroundColor: widget.todayBackgroundColor,
      pressedBackgroundColor: widget.datePressedBackgroundColor,
      decorationAlignment: () {
        /// If date is contain in decorations list, use decorations Alignment
        if (widget.decorations.isNotEmpty) {
          final List<DecorationItem> matchDate = widget.decorations
              .where((ele) => compareDate(ele.date, date))
              .toList();
          return matchDate.isNotEmpty
              ? matchDate[0].decorationAlignment
              : FractionalOffset.center;
        }
        return FractionalOffset.center;
      }(),
      dayShapeBorder: widget.dayShapeBorder,
      onDatePressed: (datePressed) {
        controller._selectedDate = datePressed;
        widget.onDatePressed(datePressed);
      },
      onDateLongPressed: (datePressed) {
        controller._selectedDate = datePressed;
        widget.onDateLongPressed(datePressed);
      },
      decoration: () {
        /// If date is contain in decorations list, use decorations Widget
        if (widget.decorations.isNotEmpty) {
          final List<DecorationItem> matchDate = widget.decorations
              .where((ele) => compareDate(ele.date, date))
              .toList();
          return matchDate.isNotEmpty ? matchDate[0].decoration : null;
        }
        return null;
      }(),
      cacheStream: _cacheStream);

  @override
  void dispose() {
    super.dispose();
    _cacheStream.close();
  }
}
