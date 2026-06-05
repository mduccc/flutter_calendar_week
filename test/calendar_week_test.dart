// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/strings.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';
import 'package:flutter_calendar_week/src/utils/find_current_week_index.dart';
import 'package:flutter_calendar_week/src/utils/separate_weeks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  CalendarWeekController? controller;

  setUp(() {
    controller = CalendarWeekController();
  });
  group('CalendarWeek test', () {
    test('compareDate is working correctly', () {
      expect(compareDate(DateTime.now(), DateTime.now()), true);
      expect(compareDate(DateTime.now(), DateTime.now().add(Duration(days: 1))),
          false);
    });

    test('separateWeeks and compareDate is working correctly', () {
      final List<WeekItem> separated = separateWeeks(DateTime(2020, 1, 1),
          DateTime(2020, 1, 15), dayOfWeekDefault, monthDefaults);
      expect(separated.length, 3);
      for (int i = 0; i < separated.length; i++) {
        for (int j = 0; j < separated[i].days.length - 1; j++) {
          if (separated[i].days[j] == null) {
            break;
          }
          if (j + i < separated[i].days.length &&
              separated[i].days[j + 1] != null) {
            expect(
                separated[i].days[j]!.isBefore(separated[i].days[j + 1]!), true);
          }
        }
      }

      int currentWeekIndex =
          findCurrentWeekIndexByDate(DateTime(2020, 1, 15), separated);
      expect(currentWeekIndex, separated.length - 1);
      currentWeekIndex =
          findCurrentWeekIndexByDate(DateTime(2020, 1, 1), separated);
      expect(currentWeekIndex, 0);
      currentWeekIndex =
          findCurrentWeekIndexByDate(DateTime(2020, 1, 9), separated);
      expect(currentWeekIndex, 1);
    });
    testWidgets('showMonth: false hides the month row',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: CalendarWeek(
            minDate: DateTime.now().add(Duration(days: -365)),
            maxDate: DateTime.now().add(Duration(days: 365)),
            showMonth: false,
          ),
        ),
      ));

      // The default month text (e.g. "January") must not appear anywhere.
      for (final month in monthDefaults) {
        expect(find.text(month), findsNothing);
      }
    });

    testWidgets('showMonth: true (default) shows the month row',
        (WidgetTester tester) async {
      final now = DateTime.now();
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: CalendarWeek(
            minDate: now.add(Duration(days: -365)),
            maxDate: now.add(Duration(days: 365)),
            showMonth: true,
          ),
        ),
      ));

      // At least one month name must be visible.
      final monthTexts = monthDefaults
          .map((m) => find.text(m))
          .where((f) => tester.any(f))
          .toList();
      expect(monthTexts, isNotEmpty);
    });

    testWidgets('CalendarWeek widget is working correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: CalendarWeek(
            minDate: DateTime.now().add(Duration(days: -365)),
            maxDate: DateTime.now().add(Duration(days: 365)),
            controller: controller,
          ),
        ),
      ));

      /// Test select date is less than [maxDate],
      /// update [selectedDate] and [rangeWeekDate]
      final DateTime selectDateA = DateTime.now().add(Duration(days: 8));
      controller!.jumpToDate(selectDateA);
      int diff = controller!.selectedDate.difference(selectDateA).inDays;
      expect(diff, 0);
      expect(controller!.rangeWeekDate[0]!.isBefore(selectDateA), true);
      expect(
          controller!.rangeWeekDate[controller!.rangeWeekDate.length - 1]!
              .isAfter(selectDateA),
          true);

      /// Test select is more than [maxDate], keep [selectedDate]
      final DateTime selectDateB = DateTime.now().add(Duration(days: 1000));
      controller!.jumpToDate(selectDateB);
      diff = controller!.selectedDate.difference(selectDateA).inDays;
      expect(diff, 0);
    });

    test('daysOfWeekForLocale returns 7 upper-case labels for English',
        () async {
      await initializeDateFormatting('en');
      final days = daysOfWeekForLocale('en');
      expect(days.length, 7);
      // All labels must be upper-case non-empty strings
      for (final d in days) {
        expect(d, isNotEmpty);
        expect(d, equals(d.toUpperCase()));
      }
      // English abbreviated days start Mon → Mon
      expect(days.first, 'MON');
      expect(days.last, 'SUN');
    });

    test('monthsForLocale returns 12 upper-case labels for English', () async {
      await initializeDateFormatting('en');
      final months = monthsForLocale('en');
      expect(months.length, 12);
      for (final m in months) {
        expect(m, isNotEmpty);
        expect(m, equals(m.toUpperCase()));
      }
      expect(months.first, 'JANUARY');
      expect(months.last, 'DECEMBER');
    });

    test('daysOfWeekForLocale returns French labels after initialization',
        () async {
      await initializeDateFormatting('fr');
      final days = daysOfWeekForLocale('fr');
      expect(days.length, 7);
      for (final d in days) {
        expect(d, isNotEmpty);
        expect(d, equals(d.toUpperCase()));
      }
      // French Monday abbreviation should not be the English 'MON'
      expect(days.first, isNot('MON'));
    });

    testWidgets('locale parameter generates localized day/month labels',
        (WidgetTester tester) async {
      await initializeDateFormatting('fr');
      final frDays = daysOfWeekForLocale('fr');
      final frMonths = monthsForLocale('fr');

      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: CalendarWeek(
            locale: 'fr',
            minDate: DateTime.now().add(Duration(days: -365)),
            maxDate: DateTime.now().add(Duration(days: 365)),
            showMonth: true,
          ),
        ),
      ));

      // Default English labels must NOT appear
      for (final day in dayOfWeekDefault) {
        expect(find.text(day), findsNothing);
      }

      // At least one French day label must be visible
      final visibleDays =
          frDays.where((d) => tester.any(find.text(d))).toList();
      expect(visibleDays, isNotEmpty);

      // At least one French month label must be visible
      final visibleMonths =
          frMonths.where((m) => tester.any(find.text(m))).toList();
      expect(visibleMonths, isNotEmpty);
    });

    testWidgets(
        'explicit dayOfWeek list overrides locale when both are provided',
        (WidgetTester tester) async {
      const customDays = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: CalendarWeek(
            locale: 'fr',
            dayOfWeek: customDays,
            minDate: DateTime.now().add(Duration(days: -365)),
            maxDate: DateTime.now().add(Duration(days: 365)),
          ),
        ),
      ));

      // Custom labels must appear; locale-derived French labels must not
      final visibleCustom =
          customDays.where((d) => tester.any(find.text(d))).toList();
      expect(visibleCustom, isNotEmpty);
    });
  });
}
