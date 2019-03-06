import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calendar',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _currentDate = new DateTime.now();

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  String _currentMonth = '';

  // Select Date
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2016),
      lastDate: new DateTime(2029)
    );

    if(picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    };
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker (
      context: context,
      initialTime: _time
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_date.toString()}');
      setState(() {
        _time = picked;
      });
    }
  }

  // Events
  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2018, 12, 10): [
        new Event(
          date: new DateTime(2018, 12, 10),
          title: 'Event',
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime(2018, 12, 25),
        new Event(
          date: new DateTime(2018, 12, 25),
          title: 'Event 5',
        ));

    _markedDateMap.addAll(new DateTime(2018, 12, 11), [
      new Event(
        date: new DateTime(2018, 12, 11),
        title: 'Event 1',
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      // Switch to day pressed
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },

      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: false, // null for not showing hidden events indicator
      showHeader: false,
      markedDateIconBuilder: (event) {
        return event.icon;
      },

      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      todayButtonColor: Colors.deepPurple[300],
      selectedDayTextStyle: TextStyle(
        color: Colors.deepPurple,
      ),
      selectedDayButtonColor: Colors.deepPurple[100],

      weekdayTextStyle: TextStyle (
        color: Colors.black,
      ),
      weekendTextStyle: TextStyle (
        color: Colors.black,
      ),

      minSelectedDate: _currentDate,
      maxSelectedDate: _currentDate.add(Duration(days: 60)),
      onCalendarChanged: (DateTime date) {
        this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushNewEvent,
        child: Icon(Icons.add),
        tooltip: 'Add Event',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //custom icon
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarousel,
            ), // This trailing comma makes auto-formatting nicer for build methods.

            //custom icon without header
            Container(
             margin: EdgeInsets.only(
               top: 30.0,
               bottom: 16.0,
               left: 16.0,
               right: 16.0,
              ),

              child: new Row(
                children: <Widget>[
                  //new Text('Date selected: ${_date.toString()}'),
                  Expanded(
                    child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )
                  ),

                  // left arrow
                  new IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      setState(() {
                        _currentDate =
                          _currentDate.subtract(Duration(days: 30));
                        _currentMonth =
                          DateFormat.yMMM().format(_currentDate);
                      });
                    },
                  ),
                  // calendar day selection
                  new IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: (){_selectDate(context);}
                  ),
                  // right arrow
                  new IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      setState(() {
                        _currentDate = _currentDate.add(Duration(days: 30));
                        _currentMonth = DateFormat.yMMM().format(_currentDate);
                      });
                    },
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarouselNoHeader,
            ),
          ],
        ),
      ),
    );
  }

  void _pushNewEvent() {
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    DateTime selectedDate = _date;

    // Select Date
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: new DateTime(2016),
          lastDate: new DateTime(2029)
      );

      if(picked != null && picked != _date) {
        print('Date selected: ${_date.toString()}');
        setState(() {
          _date = picked;
        });
      };
    }

    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay picked = await showTimePicker (
          context: context,
          initialTime: _time
      );

      if(picked != null && picked != _time) {
        print('Time selected: ${_date.toString()}');
        setState(() {
          _time = picked;
        });
      }
    }

    // Route to new event page
    Navigator.of(context).push(
      // Pushes the route to the favorites page to the Navigator's stack
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {

          // Horizontal dividers
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Add Event'),
            ),



            body: new SafeArea(
                top: false,
                bottom: false,
                child: new Form(
                    key: _formKey,
                    autovalidate: true,
                    child: new ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        new TextFormField(
                          decoration: const InputDecoration(
                            //icon: const Icon(Icons.event),
                            labelText: 'Enter title',
                          ),
                        ),

                        Row(
                          children: [
                            new IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: (){_selectDate(context);}
                            ),

                            new Text('Date: ${DateFormat('MMMM dd, yyyy').format(_date)}'),
                          ],
                        ),

                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            labelText: 'Date',
                          ),
                          keyboardType: TextInputType.datetime,
                        ),

                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.watch_later),
                            labelText: 'Time',
                          ),
                        ),

                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.location_on),
                            labelText: 'Location',
                          ),
                        ),

                        new Container(
                            padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                            child: new RaisedButton(
                              child: const Text('Submit'),
                              onPressed: null,
                            )
                        ),
                      ],
                    )
                )
            ),




          );
        },
      ),
    );
  }
}