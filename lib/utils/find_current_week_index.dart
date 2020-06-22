part of '../calendar_week.dart';

/// [findCurrentWeekIndexByDate] return -1 when cannot match
int findCurrentWeekIndexByDate(DateTime dateTime, List<_WeekItem> weeks) {
  int index = -1;
  bool matched = false;
  for (int i = 0; i < weeks.length; i++) {
    index++;
    for (int j = 0; j < weeks[i].days.length; j++) {
      if (_compareDate(dateTime, weeks[i].days[j])) {
        matched = true;
        break;
      }
    }
    if (matched) {
      break;
    }
  }

  return matched ? index : -1;
}
