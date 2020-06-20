### flutter_calendar_week
A calendar view by week

#### TODO:
- [x] Jump to date

##### IOS | Android:
<img src="https://i.imgur.com/MED4xrc.png" width="40%" height="40%"/> <img src="https://i.imgur.com/1WXg1o6.gif" width="43.3%" height="42.45%"/>

<br>

##### Web:

<img src="https://i.imgur.com/FGjnZEv.png"/>


#### Use:
```
dependencies:
  flutter_calendar_week:
    git:
      url: https://github.com/mduccc/flutter_calendar_week
      ref: 0.1.0
```

```Dart
import 'package:flutter_calendar_week/calendar_week.dart';
```

```Dart
CalendarWeek(
              height: 80,
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
            );
```
