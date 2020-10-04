import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';
/// [findCurrentWeekIndexByDate] return -1 when cannot match
int findCurrentWeekIndexByDate(DateTime dateTime, List<WeekItem> weeks) {
  int index = -1;
  bool matched = false;
  for (int i = 0; i < weeks.length; i++) {
    index++;
    for (int j = 0; j < weeks[i].days.length; j++) {
      if (compareDate(dateTime, weeks[i].days[j])) {
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
