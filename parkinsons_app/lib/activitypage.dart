import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ActivityPage extends StatelessWidget {
  ActivityPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Tracker',
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

  @override
  Widget build(BuildContext context) {

    var data = [
      new TimeSeriesSales(new DateTime(2019, 2, 13), 8855),
      new TimeSeriesSales(new DateTime(2019, 2, 14), 8676),
      new TimeSeriesSales(new DateTime(2019, 2, 15), 4120),
      new TimeSeriesSales(new DateTime(2019, 2, 16), 695),
      new TimeSeriesSales(new DateTime(2019, 2, 17), 665),
      new TimeSeriesSales(new DateTime(2019, 2, 18), 3270),
      new TimeSeriesSales(new DateTime(2019, 2, 19), 3385),
      new TimeSeriesSales(new DateTime(2019, 2, 20), 7485),
      new TimeSeriesSales(new DateTime(2019, 2, 21), 9683),
      new TimeSeriesSales(new DateTime(2019, 2, 22), 9433),
      new TimeSeriesSales(new DateTime(2019, 2, 23), 8524),
      new TimeSeriesSales(new DateTime(2019, 2, 24), 12715),
      new TimeSeriesSales(new DateTime(2019, 2, 25), 7664),
      new TimeSeriesSales(new DateTime(2019, 2, 26), 2671)

    ];

    var series = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];

    var chart = new charts.TimeSeriesChart(
      series,
      animate: true,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new SizedBox(
        height: 245.0,
        width: 600.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        title: new Text('Daily Activity',
            style: TextStyle(color: Colors.white,
                fontSize: 24.0)),
      ),
      body: SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 275,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        chartWidget
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 160,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        ListTile(
                            title: Text('2671 Steps',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 50.0
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text('Today\'s Steps',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20.0
                              ),
                              textAlign: TextAlign.center,)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 160,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                            title: Text('Goal:',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 50.0
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text('10000 Steps',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20.0
                              ),
                              textAlign: TextAlign.center,)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}