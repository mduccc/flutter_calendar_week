part of '../calendar_week.dart';

/*
  Read from minDate to madDate and split to weeks.
  Return List contain weeks and index of week item content today.
*/
dartz.Tuple2<List<_WeekItem>, int> _splitToWeek(
    DateTime minDate, DateTime maxDate, List<String> dayOfWeek) {
  /* Count until length day of week */
  int count = 1;
  /* List contain day Of Week */
  final List<String> _dayOfWeek = [];
  /* List contain day */
  final List<DateTime> _days = [];
  /* List contain weeks */
  final List<_WeekItem> _weeks = [];
  /* index of week item contain today */
  int thisWeek = 0;
  /* clone minDate object */
  DateTime minDateCloned = DateTime(
      minDate.year,
      minDate.month,
      minDate.day,
      minDate.hour,
      minDate.minute,
      minDate.second,
      minDate.millisecond,
      minDate.microsecond);

  /* Read from minDate to madDate */
  while (minDateCloned.compareTo(maxDate) < 1) {
    /* If in week */
    if (count < _maxDayOfWeek) {
      /* Add day of week to list day of week */
      _dayOfWeek.add(dayOfWeek[minDateCloned.weekday - 1]);
      /* Add day of week to list days */
      _days.add(minDateCloned);
      /* if day is today, set index of week item contain today */
      if (_compareDate(minDateCloned, _today)) {
        thisWeek = _weeks.length;
      }
      count++;
    }
    /* If is last day of week, add list list day of week and list day to a week. then add the week to list weeks */
    else if (count == _maxDayOfWeek) {
      /* Reset count */
      count = 1;
      /* Add last day of week to list day of week */
      _dayOfWeek.add(dayOfWeek[minDateCloned.weekday - 1]);
      /* Add last day to list days */
      _days.add(minDateCloned);
      /* Add the week to list week */
      _weeks.add(
          _WeekItem(dayOfWeek: List.from(_dayOfWeek), days: List.from(_days)));
      /* clear list before add new item */
      _dayOfWeek.clear();
      _days.clear();
      /* if day is today, set index of week item contain today */
      if (_compareDate(minDateCloned, _today)) {
        thisWeek = _weeks.length - 1;
      }
    }

    /* push a next day */
    minDateCloned = minDateCloned.add(Duration(days: 1));
  }

  // if while about is not end with last day of week, add add items less
  if (count > 1) {
    _weeks.add(
        _WeekItem(dayOfWeek: List.from(_dayOfWeek), days: List.from(_days)));
    _dayOfWeek.clear();
    _days.clear();
  }

  /* Fit day to list week */
  if (_weeks.isNotEmpty &&
      _weeks[_weeks.length - 1].dayOfWeek.length < _maxDayOfWeek) {
    for (int i = 0; i < _maxDayOfWeek; i++) {
      if (i > _weeks[_weeks.length - 1].dayOfWeek.length - 1) {
        _weeks[_weeks.length - 1].dayOfWeek.add(dayOfWeek[i]);
        _weeks[_weeks.length - 1].days.add(null);
      }
    }
  }

  return dartz.Tuple2<List<_WeekItem>, int>(_weeks, thisWeek);
}
