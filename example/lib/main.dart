import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Calendar Week Example',
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalendarWeekController _controller = CalendarWeekController();

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.jumpToDate(DateTime.now());
            setState(() {});
          },
          child: Icon(Icons.today),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepOrange,
          title: Text('Calendar Week ( SUN - SAT )'),
        ),
        body: Column(children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CalendarWeek(
              controller: _controller,
              height: 100,
              showMonth: true,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              todayBackgroundColor: Colors.deepOrange.withOpacity(0.7),
              todayDateStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              dateStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              dayOfWeekStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              weekendsIndexes: [5, 6],
              weekendsStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
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
              monthViewBuilder: (DateTime time) => Align(
                alignment: FractionalOffset.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    DateFormat.yMMMM().format(time),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              decorations: [
                // DecorationItem(
                //     decorationAlignment: FractionalOffset.bottomRight,
                //     date: DateTime.now(),
                //     decoration: Icon(
                //       Icons.today,
                //       color: Colors.blue,
                //     )),
                // DecorationItem(
                //     date: DateTime.now().add(Duration(days: 3)),
                //     decoration: Text(
                //       'Holiday',
                //       style: TextStyle(
                //         color: Colors.brown,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Weekday-${_controller.selectedDate.weekday}',
                  style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                ),
                SizedBox(height: 10),
                Text(
                  '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
                  style: TextStyle(fontSize: 25, color: Colors.teal),
                ),
              ],
            ),
          )
        ]),
      );
}
