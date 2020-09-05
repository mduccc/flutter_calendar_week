import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'calendar',
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final CalendarWeekController _controller = CalendarWeekController();

  int i = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            i++;
            final newDate = DateTime.now().add(Duration(days: i));
            _controller.jumpToDate(newDate);
            setState(() {
              _selectedDate = newDate;
            });
          },
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: Text('Calendar'),
        ),
        body: Column(children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1)
            ]),
            child: CalendarWeek(
              onWeekChanged: () {},
              controller: _controller,
              height: 100,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              onDatePressed: (DateTime datetime) {
                setState(() {
                  _selectedDate = datetime;
                });
              },
              onDateLongPressed: (DateTime datetime) {
                setState(() {
                  _selectedDate = datetime;
                });
              },
              weekendsStyle:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              dayOfWeekStyle:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              dayOfWeekAlignment: FractionalOffset.bottomCenter,
              dateStyle:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
              dateAlignment: FractionalOffset.topCenter,
              todayDateStyle:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.w400),
              todayBackgroundColor: Colors.black.withOpacity(0.15),
              pressedDateBackgroundColor: Colors.blue,
              pressedDateStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              dateBackgroundColor: Colors.transparent,
              backgroundColor: Colors.white,
              dayOfWeek: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
              showMonth: true,
              spaceBetweenLabelAndDate: 0,
              dayShapeBorder: CircleBorder(),
              decorations: [
                DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: Icon(
                      Icons.today,
                      color: Colors.blue,
                    )),
                DecorationItem(
                    date: DateTime.now().add(Duration(days: 3)),
                    decoration: Text(
                      'Holiday',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                style: TextStyle(fontSize: 30),
              ),
            ),
          )
        ]),
      );
}
