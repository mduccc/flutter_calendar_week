import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';

void main() async {
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'CalendarWeek Example',
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalendarWeekController _controller = CalendarWeekController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.jumpToDate(DateTime.now());
            setState(() {});
          },
          child: const Icon(Icons.today),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: const Text('CalendarWeek'),
        ),
        body: SizedBox(
          child: Column(children: [
            Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, spreadRadius: 1)]),
                child: CalendarWeek(
                  /// added decoration parameter for calendar
                  calendarDecoration: const BoxDecoration(
                    color: Colors.green,
                  ),

                  dayWidth: 30,
                  pressedDateBackgroundColor: Colors.black,
                  todayBackgroundColor: Colors.yellow,

                  /// added decoration parameter for day item
                  dayDecoration: const BoxDecoration(
                    color: Colors.grey,
                  ),

                  /// added decoration parameter for day dayOfWeek
                  dayOfWeekDecoration: const BoxDecoration(
                    color: Colors.redAccent,
                  ),
                  controller: _controller,
                  height: 100,
                  showMonth: true,
                  minDate: DateTime.now().add(
                    const Duration(days: -365),
                  ),
                  maxDate: DateTime.now().add(
                    const Duration(days: 365),
                  ),
                  onDatePressed: (DateTime datetime) {
                    // Do something
                    setState(() {});
                  },
                  onDateLongPressed: (DateTime datetime) {
                    // Do something
                  },
                  onWeekChanged: () {
                    // Do something
                  },
         
                  decorations: [
                    DecorationItem(
                        decorationAlignment: FractionalOffset.bottomRight,
                        date: DateTime.now(),
                        decoration: const Icon(
                          Icons.today,
                          color: Colors.blue,
                        )),
                    DecorationItem(
                        date: DateTime.now().add(const Duration(days: 3)),
                        decoration: const Text(
                          'Holiday',
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                )),
            Expanded(
              child: Center(
                child: Text(
                  '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ]),
        ),
      );
}
