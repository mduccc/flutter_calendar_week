part of '../calendar_week.dart';

/* Compare dates, return a bool value. True is same date or false else */
bool _compareDate(DateTime dateA, DateTime dateB) {
  if (dateA?.day == dateB?.day &&
      dateA?.month == dateB?.month &&
      dateA?.year == dateB?.year) {
    return true;
  }

  return false;
}
