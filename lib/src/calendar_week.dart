import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/custom_scroll_behaiver.dart';
import 'package:flutter_calendar_week/src/date_item.dart';
import 'package:flutter_calendar_week/src/models/decoration_item.dart';
import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/strings.dart';
import 'package:flutter_calendar_week/src/utils/cache_stream.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';
import 'package:flutter_calendar_week/src/utils/find_current_week_index.dart';
import 'package:flutter_calendar_week/src/utils/separate_weeks.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'item_container.dart';

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
                monthViewBuilder: (date) => Text(date.toString()),
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
  List<DateTime?> get rangeWeekDate =>
      _weeks.isNotEmpty ? _weeks[_currentWeekIndex].days.where((ele) => ele != null).toList() : [];

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
  /// localization [String] tr - en etc
  /// intl localization
  final String localization;

  /// day text name format [DateFormat] DateFormat.MMM
  /// intl localization
  final DateFormat Function(String locale)? dayFormatter;

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

  /// Calendar start from [minDate]
  final DateTime minDate;

  /// Calendar end at [maxDate]
  final DateTime maxDate;

  /// Style of months
  final Widget Function(DateTime)? monthViewBuilder;

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
  final List<String>? daysOfWeek;

  /// List contain title months
  final List<String>? months;

  /// Condition show month
  final bool monthDisplay;

  /// List contain indexes of weekends from days titles list
  final List<int> weekendsIndexes;

  /// Margin day of week row
  final EdgeInsets marginDayOfWeek;

  /// Margin month row
  final EdgeInsets marginMonth;

  /// Shape of day
  final BoxShape dayShapeBorder;

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
    this.monthViewBuilder,
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
    this.onWeekChanged,
    this.dayOfWeekDecoration,
    this.dayDecoration,
    this.dayWidth,
    this.dayHeight,
    this.dayOfWeekHeight,
    this.dayOfWeekWidth,
    this.calenderDecoration,
    this.localization,
    this.dayFormatter,
  )   : assert(minDate.isBefore(maxDate)),
        super(key: key);

  factory CalendarWeek({
    Key? key,
    DateTime? maxDate,
    DateTime? minDate,
    double height = 100,
    Widget Function(DateTime)? monthViewBuilder,
    TextStyle dayOfWeekStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
    FractionalOffset monthAlignment = FractionalOffset.center,
    TextStyle dateStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
    TextStyle todayDateStyle = const TextStyle(color: Colors.orange, fontWeight: FontWeight.w400),
    Color todayBackgroundColor = Colors.black12,
    Color pressedDateBackgroundColor = Colors.blue,
    TextStyle pressedDateStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
    Color dateBackgroundColor = Colors.transparent,
    Function(DateTime)? onDatePressed,
    Function(DateTime)? onDateLongPressed,
    Color backgroundColor = Colors.white,
    List<String>? dayOfWeek,
    List<String>? month,
    bool showMonth = true,
    List<int> weekendsIndexes = weekendsIndexesDefault,
    TextStyle weekendsStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
    EdgeInsets marginMonth = const EdgeInsets.symmetric(vertical: 4),
    EdgeInsets marginDayOfWeek = const EdgeInsets.symmetric(vertical: 4),
    BoxShape dayShapeBorder = BoxShape.circle,
    List<DecorationItem> decorations = const [],
    CalendarWeekController? controller,
    Function()? onWeekChanged,
    BoxDecoration? dayOfWeekDecoration,
    BoxDecoration? dayDecoration,
    double? dayWidth,
    double? dayHeight,
    double? dayOfWeekHeight,
    double? dayOfWeekWidth,
    BoxDecoration? calendarDecoration,
    String localization = "tr",
    DateFormat Function(String locale)? dayFormatter,
  }) =>
      CalendarWeek._(
        key,
        maxDate ?? DateTime.now().add(Duration(days: 180)),
        minDate ?? DateTime.now().add(Duration(days: -180)),
        height,
        monthViewBuilder,
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
        onWeekChanged ?? () {},
        dayOfWeekDecoration,
        dayDecoration,
        dayWidth,
        dayHeight,
        dayOfWeekHeight,
        dayOfWeekWidth,
        calendarDecoration,
        localization,
        dayFormatter,
      );

  @override
  _CalendarWeekState createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {
  /// [_streamController] for emit date press event
  final CacheStream<DateTime?> _cacheStream = CacheStream<DateTime?>();

  /// [_stream] for listen date change event
  Stream<DateTime?>? _stream;

  /// Page controller
  PageController? _pageController;

  CalendarWeekController _defaultCalendarController = CalendarWeekController();

  CalendarWeekController get controller => widget.controller ?? _defaultCalendarController;

  void _jumToDateHandler(DateTime? dateTime) {
    _cacheStream.add(dateTime);
    _pageController?.animateToPage(widget.controller!._currentWeekIndex,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  static List<String> getDaysOfWeek([String? locale]) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(DateFormat.WEEKDAY, locale).format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  void _setUp() async {
    //assert(controller.hasClient == false);
    _stream ??= _cacheStream.stream!.asBroadcastStream();

    List<String> localizationMonths = [];
    List<String> localizationDayOfWeek = [];

    await initializeDateFormatting();

    /// if months is empty
    if (widget.months?.isEmpty ?? true) {
      localizationMonths = List.generate(DateTime.monthsPerYear, (index) {
        var formatDayText = widget.dayFormatter != null
            ? widget.dayFormatter!(widget.localization)
            : DateFormat.MMM(widget.localization);
        return formatDayText.format(DateTime(DateTime.now().year, index));
      });
    }

    /// if months is empty
    if (widget.daysOfWeek?.isEmpty ?? true) {
      localizationDayOfWeek = getDaysOfWeek(widget.localization);
    }
    var c = separateWeeks(widget.minDate, widget.maxDate, widget.daysOfWeek ?? localizationDayOfWeek,
        widget.months ?? localizationMonths);
    controller
      .._weeks.clear()
      .._weeks.addAll(c)

      /// [_currentWeekIndex] is index of week in [List] weeks contain today

      .._currentWeekIndex = findCurrentWeekIndexByDate(controller._today, controller._weeks)
      .._widgetJumpToDate = _jumToDateHandler
      .._hasClient = true;

    /// Init Page controller
    /// Set [initialPage] is page contain today
    _pageController = PageController(initialPage: controller._currentWeekIndex);
    setState(() {});
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
        color: widget.calenderDecoration == null ? widget.backgroundColor : null,
        width: double.infinity,
        height: widget.height,
        decoration: widget.calenderDecoration,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: _pageController == null
              ? SizedBox()
              : PageView.builder(
                  controller: _pageController,
                  itemCount: controller._weeks.length,
                  onPageChanged: (currentPage) {
                    widget.controller!._currentWeekIndex = currentPage;
                    widget.onWeekChanged();
                  },
                  itemBuilder: (_, i) {
                    var week = controller._weeks[i];
                    return _week(week);
                  }),
        ),
      );

  /// Layout of week
  Widget _week(WeekItem weeks) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Month
          (widget.monthDisplay && widget.monthViewBuilder != null && weeks.days.firstWhere((el) => el != null) != null)
              ? widget.monthViewBuilder!(weeks.days.firstWhere((el) => el != null)!)
              : _monthItem(weeks.month),

          /// Day of week layout
          _dayOfWeek(weeks.dayOfWeek),

          /// Date layout
          Expanded(child: _dates(weeks.days))
        ],
      );

  /// Day of week item layout
  Widget _monthItem(String title) => Align(
        alignment: widget.monthAlignment,
        child: Container(
            margin: widget.marginMonth,
            child: Text(
              title,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )),
      );

  /// Day of week layout
  Widget _dayOfWeek(List<String> dayOfWeek) => Container(
        margin: widget.marginDayOfWeek,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: dayOfWeek.map(_dayOfWeekItem).toList()),
      );

  /// Day of week item layout
  Widget _dayOfWeekItem(String title) => ItemContainer(
        width: widget.dayOfWeekWidth,
        height: widget.dayOfWeekHeight,
        decoration: widget.dayOfWeekDecoration,
        child: Text(
          title,
          style: widget.weekendsIndexes.indexOf(widget.daysOfWeek?.indexOf(title) ?? -1) != -1
              ? widget.weekendsStyle
              : widget.dayOfWeekStyle,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );

  /// Date layout
  Widget _dates(List<DateTime?> dates) =>
      Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: dates.map(_dateItem).toList()));

  /// Date item layout
  Widget _dateItem(DateTime? date) => ItemContainer(
        width: widget.dayWidth,
        height: widget.dayHeight,
        decoration: widget.dayDecoration,
        child: DateItem(
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
                final List<DecorationItem> matchDate =
                    widget.decorations.where((ele) => compareDate(ele.date, date)).toList();
                return matchDate.isNotEmpty ? matchDate[0].decorationAlignment : FractionalOffset.center;
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
                final List<DecorationItem> matchDate =
                    widget.decorations.where((ele) => compareDate(ele.date, date)).toList();
                return matchDate.isNotEmpty ? matchDate[0].decoration : null;
              }
              return null;
            }(),
            cacheStream: _cacheStream),
      );

  @override
  void dispose() {
    super.dispose();
    _cacheStream.close();
  }
}
