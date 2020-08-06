part of '../calendar_week.dart';

class _WeekItem {
  final String month;
  final List<String> dayOfWeek;
  final List<DateTime> days;

  _WeekItem({
    this.month = '',
    this.dayOfWeek = const [],
    this.days = const []
  });
}
