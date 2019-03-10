import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/src/material/time.dart';


class Event {
    String title = '';
    DateTime date;
    TimeOfDay startTime = new TimeOfDay.now();
    TimeOfDay endTime = new TimeOfDay.now();
    String location = '';
}
