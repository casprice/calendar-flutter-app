import 'package:flutter/material.dart';
import 'package:flutter/src/material/time.dart';
import 'dart:async';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
//import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Event.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage();

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
  // Date selected by the user
  DateTime _selectedDate = new DateTime.now();
  // Today's date
  DateTime _currentDate = new DateTime.now();
  // Time selected by the user
  TimeOfDay _startTime = new TimeOfDay.now();
  // Time selected by the user
  TimeOfDay _endTime = new TimeOfDay.fromDateTime((new DateTime.now()).add(Duration(hours: 1)));
  // Calendar's current month

  String _currentMonth = '';
  final TextEditingController _controller = new TextEditingController();

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2029),
    );

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try
    {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isAfter(new DateTime.now());
  }

  // Select date from the calendar icon
  Future<Null> _selectDate(BuildContext context) async {
    // Settings for date picker
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: new DateTime(2016),
      lastDate: new DateTime(2029)
    );

    // If picked time is chosen and is not the same as the already selected date, update the selected date
    if(picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        //_currentDate = _date;
        _currentMonth = DateFormat.yMMM().format(_currentDate);
      });
      // Debug message
      print('Date selected: ${_selectedDate.toString()}');
    };
  }

  // List of marked events
  EventList<Event> _markedDateMap = new EventList<Event>();

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    // Add more events to _markedDateMap EventList
    /*
    for(Event event in _markedDateMap) {
      Event newEvent = new Event();
      newEvent.date = event.date;
      newEvent.title = event.title;
      _markedDateMap.add(newEvent.date, newEvent);
    }
    */

    /*
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
    ]);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      // Switch to day pressed
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _selectedDate = date);

        //events.forEach((event) => print(event.title));
      },

      // Calendar Carousel custom settings
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _selectedDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: false, // null for not showing hidden events indicator
      showHeader: false,
      markedDateIconBuilder: (event) {
        //return event.icon;
      },

      // Calendar colors
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

      // Most recent date that is interactive
      minSelectedDate: _currentDate.subtract(Duration(days: 1)),
      maxSelectedDate: new DateTime(2029),

      // When calendar changes, update the month
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
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: _calendarCarousel,
            ), // This trailing comma makes auto-formatting nicer for build methods.

            //custom icon without header
            Container(
             margin: EdgeInsets.only(
               top: 30.0,
               bottom: 14.0,
               left: 16.0,
               right: 16.0,
              ),

              child: new Row(
                children: <Widget>[
                  //new Text('Date selected: ${_date.toString()}'),

                  // left arrow
                  new IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      setState(() {
                        _selectedDate =
                            _selectedDate.subtract(Duration(days: 30));
                        _currentMonth =
                            DateFormat.yMMM().format(_selectedDate);
                      });
                    },
                  ),

                  Expanded(
                    child: new Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),


                  /* calendar day selection
                  new IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: (){
                      setState(() {
                        _selectDate(context);
                        _currentMonth = DateFormat.yMMM().format(_selectedDate);
                      });
                    },
                  ),*/
                  // right arrow
                  new IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.add(Duration(days: 30));
                        _currentMonth = DateFormat.yMMM().format(_selectedDate);
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

            /*for (Event event in events) {
              new Column(
                new Row(
                  children: new Text('Event: ' + event.title),
                ),
                new Row(
                  children: new Text('Date: ' + event.date),
                )
              );
            }*/
          ],
        ),
      ),
    );
  }

  void _pushNewEvent() {
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    DateTime _eventDate = _selectedDate;
    Event newEvent = new Event();


    /* FOR THE DATE/TIME PICKER THAT DOESN'T WORK
    // Select Date
    Future<Null> _selectDate(BuildContext context) async {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: _eventDate,
          firstDate: new DateTime(2016),
          lastDate: new DateTime(2029)
      );

      if(picked != null && picked != _eventDate) {
        setState(() {
          _eventDate = picked;
          _selectedDate = picked;
        });
        print('Event date selected: ${_eventDate.toString()}');
      };
    }

    // Select time
    TimeOfDay _selectTime(BuildContext context, TimeOfDay time) async {
      TimeOfDay picked = await showTimePicker (
          context: context,
          initialTime: time,
      );

      if(picked != null && picked != time) {
        setState(() {
          time = picked;
        });
        print('Time selected: ${time.toString()}');
      }

      return time;
    }
    */

    void showMessage(String message, [MaterialColor color = Colors.red]) {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
              backgroundColor: color,
              content: new Text(message)
          )
      );
    }

    // Submit the form
    void _submitForm() {
      final FormState form = _formKey.currentState;

      if(!form.validate()) {
        showMessage('Event information is not valid! Please fill out all fields.');
      } else {
        form.save(); // Invokes each onSaved event

        print('=========================================');
        print('Form save called, newEvent is now up to date...');
        print('Title: ${newEvent.title}');
        print('Start time: ${newEvent.startTime}');
        print('End time: ${newEvent.endTime}');
        print('Location: ${newEvent.location}');
        print('=========================================');
        print('Submitting to back end...');
        showMessage('New event created for ${newEvent.title}', Colors.blue);
        Navigator.of(context).pop();
      }
    }

    // Route to new event page
    Navigator.of(context).push(
      // Pushes the route to the favorites page to the Navigator's stack
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // Horizontal dividers
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              title: const Text('Add Event'),
            ),

            body: new SafeArea(
                top: false,
                bottom: false,
                child: new Form(
                    key: _formKey,
                    autovalidate: false,
                    child: new ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        // Title
                        new TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Enter title',
                          ),
                          validator: (val) => val.isEmpty ? 'Title is required' : null,
                          onSaved: (val) => newEvent.title = val,
                        ),

                        /* DATE/TIME PICKERS THAT DON'T UPDATE TEXT
                        // Select Date
                        new GestureDetector(
                          onTap: (){
                            _selectDate(context);
                            //newEvent.date = _eventDate;
                          },

                          child: new Container(
                            padding: const EdgeInsets.only(top: 17.0),
                            child: new Row(
                              children: [
                                new IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: (){
                                    _selectDate(context);
                                    //newEvent.date = _eventDate;
                                  },
                                ), // IconButton

                                new Text(
                                  "Date: ${DateFormat('MMMM d, yyyy').format(_eventDate)}",
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ), // Text

                              ], // children
                            ), // Row
                          ), // Container
                        ), // GestureDetector


                        // Select start time
                        new GestureDetector(
                          onTap: (){
                            _selectTime(context, _startTime);
                            //newEvent.startTime = _startTime;
                            //print("newEvent.startTime = " + newEvent.startTime);
                          },

                          child: new Container(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: new Row(
                              children: [
                                new IconButton(
                                    icon: Icon(Icons.access_time),
                                    onPressed: (){
                                      _startTime = _selectTime(context, _startTime);
                                      //newEvent.startTime = _startTime;
                                    }
                                ),

                                new Text(
                                    'Start time:    ' + _startTime.format(context),
                                    style: new TextStyle(
                                      fontSize: 16.0,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Select end time
                        new GestureDetector(
                          onTap: (){
                            _selectTime(context, _endTime);
                            //newEvent.endTime = _endTime;
                          },

                          child: new Container(
                            padding: const EdgeInsets.only(top: 12.0, left: 50.0, bottom: 5.0),
                            child: new Row(
                              children: [
                                new Text(
                                  'End time:     ' + _endTime.format(context),
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                         ),


                        // Input date
                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            labelText: 'Date',
                          ),

                          keyboardType: TextInputType.datetime,
                        ),
                        */

                        new Row(children: <Widget>[
                          new Expanded(
                              child: new TextFormField(
                                decoration: new InputDecoration(
                                  icon: const Icon(Icons.calendar_today),
                                  labelText: 'Date',
                                ),
                                controller: _controller,
                                keyboardType: TextInputType.datetime,
                                validator: (val) =>
                                isValidDob(val) ? null : 'Not a valid date',
                                onSaved: (val) => _eventDate = convertToDate(val),
                              )),
                          new IconButton(
                            icon: new Icon(Icons.more_horiz),
                            tooltip: 'Choose date',
                            onPressed: (() {
                              _chooseDate(context, _controller.text);
                            }),
                          )
                        ]),

                        // Input time
                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.watch_later),
                            labelText: 'Start time',
                          ),
                          keyboardType: TextInputType.datetime,
                        ),

                        // Input time
                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.watch_later),
                            labelText: 'End time',
                          ),
                          keyboardType: TextInputType.datetime,
                        ),


                        // Input location
                        new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.location_on),
                            labelText: 'Location',
                          ),
                          validator: (val) => val.isEmpty ? 'Title is required' : null,
                          onSaved: (val) => newEvent.location = val,
                        ),

                        // Submit button
                        new Container(
                            padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                            child: new RaisedButton(
                              child: const Text('Submit'),
                              onPressed: _submitForm,
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