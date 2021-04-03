// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';
import 'package:flutter_calendar_week/src/utils/separate_weeks.dart';
import 'package:flutter_calendar_week/src/utils/find_current_week_index.dart';
import 'package:flutter_calendar_week/src/strings.dart';
import 'package:flutter_calendar_week/src/models/week_item.dart';

void main() {
  CalendarWeekController controller;

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
                separated[i].days[j].isBefore(separated[i].days[j + 1]), true);
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
      controller.jumpToDate(selectDateA);
      int diff = controller.selectedDate.difference(selectDateA).inDays;
      expect(diff, 0);
      expect(controller.rangeWeekDate[0].isBefore(selectDateA), true);
      expect(
          controller.rangeWeekDate[controller.rangeWeekDate.length - 1]
              .isAfter(selectDateA),
          true);

      /// Test select is more than [maxDate], keep [selectedDate]
      final DateTime selectDateB = DateTime.now().add(Duration(days: 1000));
      controller.jumpToDate(selectDateB);
      diff = controller.selectedDate.difference(selectDateA).inDays;
      expect(diff, 0);
    });
  });
}
