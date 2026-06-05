import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/custom_scroll_behavior.dart';
import 'package:flutter_calendar_week/src/date_item.dart';
import 'package:flutter_calendar_week/src/models/decoration_item.dart';
import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/strings.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';
import 'package:flutter_calendar_week/src/utils/find_current_week_index.dart';
import 'package:flutter_calendar_week/src/utils/separate_weeks.dart';

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

  /// Today's date, captured at controller construction time
  final DateTime today = DateTime.now();

  bool _hasClient = false;

  /// Returns [true] if attached to a [CalendarWeek] widget
  bool get hasClient => _hasClient;

  DateTime? _selectedDate;

  /// Currently selected date; falls back to [today] if nothing selected yet
  DateTime get selectedDate => _selectedDate ?? today;

  /// All dates in the currently visible week
  List<DateTime?> get rangeWeekDate => _weeks.isNotEmpty
      ? _weeks[_currentWeekIndex].days.where((ele) => ele != null).toList()
      : [];

  late Function(DateTime?) _onJumpToDate;
  late Function(int) _onJumpToWeek;

  int _currentWeekIndex = 0;

  final List<WeekItem> _weeks = [];

  /// Attaches this controller to a [CalendarWeek] widget state.
  void _attach({
    required List<WeekItem> weeks,
    required int currentWeekIndex,
    required Function(DateTime?) onJumpToDate,
    required Function(int) onJumpToWeek,
  }) {
    assert(!_hasClient, 'CalendarWeekController is already attached to a widget');
    _weeks
      ..clear()
      ..addAll(weeks);
    _currentWeekIndex = currentWeekIndex;
    _onJumpToDate = onJumpToDate;
    _onJumpToWeek = onJumpToWeek;
    _hasClient = true;
  }

  /// Detaches this controller when the widget is disposed.
  void _detach() {
    _hasClient = false;
    _weeks.clear();
  }

  /// Scrolls the calendar to the week containing [date] and selects it.
  void jumpToDate(DateTime date) {
    final newIndex = findCurrentWeekIndexByDate(date, _weeks);
    if (newIndex != -1) {
      _currentWeekIndex = newIndex;
      _selectedDate = date;
      _onJumpToDate(_selectedDate);
    }
  }

  /// Scrolls the calendar to the week containing [date] without changing the selected date.
  void jumpToWeek(DateTime date) {
    final newIndex = findCurrentWeekIndexByDate(date, _weeks);
    if (newIndex != -1) {
      _currentWeekIndex = newIndex;
      _onJumpToWeek(newIndex);
    }
  }

  /// Advances the calendar to the next week without changing the selected date.
  void nextWeek() {
    if (_currentWeekIndex < _weeks.length - 1) {
      _currentWeekIndex++;
      _onJumpToWeek(_currentWeekIndex);
    }
  }

  /// Moves the calendar back to the previous week without changing the selected date.
  void previousWeek() {
    if (_currentWeekIndex > 0) {
      _currentWeekIndex--;
      _onJumpToWeek(_currentWeekIndex);
    }
  }
}

class CalendarWeek extends StatefulWidget {
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
  final List<String> daysOfWeek;

  /// List contain title months
  final List<String> months;

  /// BCP 47 locale tag used to auto-generate day/month labels (e.g. `'fr'`,
  /// `'ja'`, `'pt_BR'`). Ignored when explicit [dayOfWeek] or [month] lists
  /// are passed. Requires [initializeDateFormatting] to have been called for
  /// non-English locales.
  final String? locale;

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

  /// Scroll physics for the week page view. Use [NeverScrollableScrollPhysics]
  /// to disable swiping.
  final ScrollPhysics? physics;

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
      this.physics,
      this.locale)
      : assert(daysOfWeek.length == 7),
        assert(months.length == 12),
        assert(minDate.isBefore(maxDate)),
        super(key: key);

  factory CalendarWeek(
          {Key? key,
          DateTime? maxDate,
          DateTime? minDate,
          double height = 100,
          Widget Function(DateTime)? monthViewBuilder,
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
          List<String>? dayOfWeek,
          List<String>? month,
          String? locale,
          bool showMonth = true,
          List<int> weekendsIndexes = weekendsIndexesDefault,
          TextStyle weekendsStyle =
              const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          EdgeInsets marginMonth = const EdgeInsets.symmetric(vertical: 4),
          EdgeInsets marginDayOfWeek = const EdgeInsets.symmetric(vertical: 4),
          BoxShape dayShapeBorder = BoxShape.circle,
          List<DecorationItem> decorations = const [],
          CalendarWeekController? controller,
          Function()? onWeekChanged,
          ScrollPhysics? physics}) =>
      CalendarWeek._(
          key,
          maxDate ?? DateTime.now().add(const Duration(days: 180)),
          minDate ?? DateTime.now().add(const Duration(days: -180)),
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
          dayOfWeek ?? (locale != null ? daysOfWeekForLocale(locale) : dayOfWeekDefault),
          month ?? (locale != null ? monthsForLocale(locale) : monthDefaults),
          showMonth,
          weekendsIndexes,
          weekendsStyle,
          marginMonth,
          marginDayOfWeek,
          dayShapeBorder,
          decorations,
          controller,
          onWeekChanged ?? () {},
          physics,
          locale);

  @override
  _CalendarWeekState createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {
  /// Notifier broadcast the currently selected date to all [DateItem] widgets
  final ValueNotifier<DateTime?> _selectedDateNotifier = ValueNotifier(null);

  late PageController _pageController;

  final CalendarWeekController _defaultController = CalendarWeekController();

  CalendarWeekController get controller =>
      widget.controller ?? _defaultController;

  void _jumToDateHandler(DateTime? dateTime) {
    _selectedDateNotifier.value = dateTime;
    _pageController.animateToPage(
      controller._currentWeekIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _jumpToWeekHandler(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _setUp() {
    assert(!controller.hasClient);
    final weeks = separateWeeks(
        widget.minDate, widget.maxDate, widget.daysOfWeek, widget.months);
    controller._attach(
      weeks: weeks,
      currentWeekIndex: findCurrentWeekIndexByDate(controller.today, weeks),
      onJumpToDate: _jumToDateHandler,
      onJumpToWeek: _jumpToWeekHandler,
    );
    _pageController = PageController(initialPage: controller._currentWeekIndex);
  }

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  Widget build(BuildContext context) => _body();

  Widget _body() => Container(
      color: widget.backgroundColor,
      width: double.infinity,
      height: widget.height,
      child: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: PageView.builder(
          controller: _pageController,
          physics: widget.physics,
          itemCount: controller._weeks.length,
          onPageChanged: (currentPage) {
            controller._currentWeekIndex = currentPage;
            widget.onWeekChanged();
          },
          itemBuilder: (_, i) => _week(controller._weeks[i]),
        ),
      ));

  Widget _week(WeekItem weeks) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (widget.monthDisplay)
            (widget.monthViewBuilder != null &&
                    weeks.days.firstWhere((el) => el != null) != null)
                ? widget.monthViewBuilder!(
                    weeks.days.firstWhere((el) => el != null)!)
                : _monthItem(weeks.month),
          _dayOfWeek(weeks.dayOfWeek),
          Expanded(child: _dates(weeks.days))
        ],
      );

  Widget _monthItem(String title) => Align(
        alignment: widget.monthAlignment,
        child: Container(
            margin: widget.marginMonth,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )),
      );

  Widget _dayOfWeek(List<String> dayOfWeek) => Container(
        margin: widget.marginDayOfWeek,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayOfWeek.map(_dayOfWeekItem).toList()),
      );

  Widget _dayOfWeekItem(String title) => Container(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
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

  Widget _dates(List<DateTime?> dates) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dates.map(_dateItem).toList());

  Widget _dateItem(DateTime? date) => DateItem(
      today: controller.today,
      date: date,
      dateStyle: compareDate(date, controller.today)
          ? widget.todayDateStyle
          : date != null && (date.weekday == 6 || date.weekday == 7)
              ? widget.weekendsStyle
              : widget.dateStyle,
      pressedDateStyle: widget.datePressedStyle,
      backgroundColor: widget.dateBackgroundColor,
      todayBackgroundColor: widget.todayBackgroundColor,
      pressedBackgroundColor: widget.datePressedBackgroundColor,
      decorationAlignment: () {
        if (widget.decorations.isNotEmpty) {
          final matches = widget.decorations
              .where((ele) => compareDate(ele.date, date))
              .toList();
          return matches.isNotEmpty
              ? matches[0].decorationAlignment
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
        if (widget.decorations.isNotEmpty) {
          final matches = widget.decorations
              .where((ele) => compareDate(ele.date, date))
              .toList();
          return matches.isNotEmpty ? matches[0].decoration : null;
        }
        return null;
      }(),
      selectedDateNotifier: _selectedDateNotifier);

  @override
  void dispose() {
    controller._detach();
    _selectedDateNotifier.dispose();
    super.dispose();
  }
}
