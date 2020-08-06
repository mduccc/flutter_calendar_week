part of 'calendar_week.dart';

/// Length of day of week
final int _maxDayOfWeek = 7;

/// List contain day of week
const List<String> _dayOfWeekDefault = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN'
];

/// List contain titles month
const List<String> _monthDefaults = [
  'JANUARY',
  'FEBRUARY',
  'MARCH',
  'APRIL',
  'MAY',
  'JUNE',
  'JULY',
  'AUGUST',
  'SEPTEMBER',
  'OCTOBER',
  'NOVEMBER',
  'DECEMBER'
];

const List<int> _weekendsIndexes = [5, 6];

/// Today date time
final _today = DateTime.now();
