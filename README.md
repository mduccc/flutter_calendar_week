### Flutter calendar week
Flutter calendar week UI package


##### IOS | Android:
<img src="https://i.imgur.com/Qv78xwO.png" width="40%" height="40%"/> <img src="https://i.imgur.com/oUQYCbC.png" width="43.29%" height="42.45%"/>

<br>

```Dart
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
```

```Dart
CalendarWeek(
              controller: CalendarWeekController(),
              height: 100,
              showMonth: true,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              
              onDatePressed: (DateTime datetime) {
                // Do something
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
            )
```
