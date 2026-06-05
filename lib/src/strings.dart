import 'package:intl/intl.dart';

/// Length of day of week
final int maxDayOfWeek = 7;

/// List contain day of week
const List<String> dayOfWeekDefault = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN'
];

/// List contain titles month
const List<String> monthDefaults = [
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

const List<int> weekendsIndexesDefault = [5, 6];

/// Generates abbreviated day-of-week labels (Mon–Sun order) for [locale].
///
/// Requires that [initializeDateFormatting(locale)] has been called for
/// non-English locales before this function is invoked.
List<String> daysOfWeekForLocale(String locale) {
  final monday = DateTime(2020, 1, 6); // a known Monday
  return List.generate(
    7,
    (i) => DateFormat('EEE', locale)
        .format(monday.add(Duration(days: i)))
        .toUpperCase(),
  );
}

/// Generates full month names (January–December order) for [locale].
///
/// Requires that [initializeDateFormatting(locale)] has been called for
/// non-English locales before this function is invoked.
List<String> monthsForLocale(String locale) => List.generate(
      12,
      (i) =>
          DateFormat('MMMM', locale).format(DateTime(2020, i + 1, 1)).toUpperCase(),
    );
