import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'activitypage.dart';
import 'calendarpage.dart';
import 'todolistpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new DailyTracker(),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class DailyTracker extends StatefulWidget {

  @override
  _DailyTrackerState createState() => new _DailyTrackerState();
}

class _DailyTrackerState extends State<DailyTracker> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ActivityPage(),
    CalendarPage(),
    ToDoListPage()
  ];


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: _children[_currentIndex],

      bottomNavigationBar: new Theme (
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.deepPurple,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.white,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.grey[400]))), // sets the inactive color of the `BottomNavigationBar`
        child: Container(
          height: 75.0,
          child: new BottomNavigationBar (
            onTap: onTabTapped,
            currentIndex: _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(
                    Icons.home,
                    size: 45,
                ),
                title: new Text('Home'),

              ),
              BottomNavigationBarItem(
                icon: new Icon(
                    Icons.calendar_today,
                    size: 40,
                ),
                title: new Text('Calendar'),

              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.format_list_bulleted,
                  size:40,
                 ),
                 title: Text('To-Do'),

              )
            ],
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}