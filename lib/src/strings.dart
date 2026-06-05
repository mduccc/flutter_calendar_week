import 'package:intl/date_symbol_data_local.dart' as _local;
import 'package:intl/date_symbols.dart';

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

/// Returns the best-matching locale key available in the intl symbol data.
/// Tries exact match first, then language-only tag (e.g. 'fr_CA' → 'fr').
String? _resolveLocale(String locale) {
  final map = _local.dateTimeSymbolMap();
  if (map.containsKey(locale)) return locale;
  final lang = locale.split(RegExp(r'[-_]')).first;
  if (map.containsKey(lang)) return lang;
  return null;
}

/// Generates abbreviated day-of-week labels in Mon–Sun order for [locale].
///
/// Falls back to [dayOfWeekDefault] if [locale] is not found in the bundled
/// intl data.
List<String> daysOfWeekForLocale(String locale) {
  final key = _resolveLocale(locale);
  if (key == null) return List.from(dayOfWeekDefault);
  final symbols = _local.dateTimeSymbolMap()[key] as DateSymbols;
  // SHORTWEEKDAYS is [Sun, Mon, Tue, Wed, Thu, Fri, Sat] — reorder to Mon–Sun
  final days = symbols.SHORTWEEKDAYS;
  return [...days.sublist(1), days[0]].map((d) => d.toUpperCase()).toList();
}

/// Generates full month names in Jan–Dec order for [locale].
///
/// Falls back to [monthDefaults] if [locale] is not found in the bundled
/// intl data.
List<String> monthsForLocale(String locale) {
  final key = _resolveLocale(locale);
  if (key == null) return List.from(monthDefaults);
  final symbols = _local.dateTimeSymbolMap()[key] as DateSymbols;
  return symbols.MONTHS.map((m) => m.toUpperCase()).toList();
}
