import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'My Clock Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _turnerSec = 0.0;
  double _turnerMin = 0.0;
  double _turnerHour = 0.0;
  Timer _myTimer;
  int _countSec = 0;
  int _countMin = 0;
  int _countHour = 0;
  // Angles calculated for each movement of the dial.
  double _angle60 = 6 * pi / 180;
  double _anglehour = 30 * pi / 180;
  List<int> _counters = [0, 0, 0];

  List<Widget> wigsSeconds = [];
  List<Widget> wigsHours = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: showClock(),
      ),
    );
  }

  showClock() {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
                color: Colors.green[900],
                onPressed: () => runTimer(),
                child: Text(
                  'Start',
                  style: TextStyle(color: Colors.white),
                )),
            FlatButton(
                color: Colors.red[900],
                onPressed: () {
                  _myTimer.cancel();
                },
                child: Text(
                  'Stop',
                  style: TextStyle(color: Colors.white),
                )),
            FlatButton(
                color: Colors.yellow[900],
                onPressed: () {
                  setState(() {
                    _turnerSec = 0.0;
                    _turnerMin = 0.0;
                    _turnerHour = 0.0;
                    _countSec = 0;
                    _countMin = 0;
                    _countHour = 0;
                    _counters = [0, 0, 0];
                  });

                  _myTimer.cancel();
                },
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),

        // Clock frame
        Center(
          child: Container(
            width: 310,
            height: 310,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        // Minute indicator
        Center(
          child: Transform.rotate(
            angle: _turnerSec,
            child: Container(
              alignment: Alignment.topCenter,
              width: 325,
              height: 325,
              child: Text('_'),
            ),
          ),
        ),
        // Second counter
        Center(
          child: Transform.rotate(
            angle: _turnerSec,
            child: Container(
              alignment: Alignment.topCenter,
              width: 220,
              height: 220,
              child: Text('${_counters[0]}     '),
            ),
          ),
        ),
        // 60 Part dial ring
        Center(
          child: Stack(
            children: secondsWidgetList(),
          ),
        ),
        // 12 Part dial ring
        Center(
          child: Stack(
            children: hoursWidgetList(),
          ),
        ),
        // Arm for seconds
        Center(
          child: Transform.rotate(
            angle: _turnerSec,
            child: Container(
                alignment: Alignment.topCenter,
                height: 275,
                width: 1,
                child: Container(
                  height: 190,
                  width: 1,
                  color: Colors.black,
                )),
          ),
        ),
        // Arm for minutes
        Center(
          child: Transform.rotate(
            angle: _turnerMin,
            child: Container(
                alignment: Alignment.topCenter,
                height: 220,
                width: 3,
                child: Container(
                  padding: EdgeInsets.all(1),
                  height: 150,
                  width: 3,
                  color: Colors.black,
                  child: Container(height: 140, width: 1, color: Colors.red),
                )),
          ),
        ),
        // Arm for hours
        Center(
          child: Transform.rotate(
            angle: _turnerHour,
            child: Container(
                alignment: Alignment.topCenter,
                height: 130,
                width: 5,
                child: Container(
                  padding: EdgeInsets.all(2),
                  height: 100,
                  width: 5,
                  color: Colors.black,
                  child: Container(height: 90, width: 1, color: Colors.red),
                )),
          ),
        ),
        // Center dot
        Center(
          child: Container(
            alignment: Alignment.topCenter,
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150), color: Colors.black),
          ),
        ),
      ],
    );
  }

  // Create the 60 parts of the dial
  List<Widget> secondsWidgetList() {
    for (var i = 0; i < 60; i++) {
      wigsSeconds.add(Transform.rotate(
          angle: (i) * (6 * pi / 180),
          child: Container(
            alignment: Alignment.topCenter,
            width: 295,
            height: 295,
            child: Text(
              ' ${i.toString()} ',
              style: TextStyle(
                fontSize: 9,
                backgroundColor: _countMin == i ? Colors.black : Colors.white,
                color: _countMin == i ? Colors.white : Colors.black,
              ),
            ),
          )));
    }
    return wigsSeconds;
  }

  // Create the 12 parts of the dial for hours
  List<Widget> hoursWidgetList() {
    for (var i = 0; i < 12; i++) {
      wigsHours.add(Transform.rotate(
          angle: (i + 1) * (30 * pi / 180),
          child: Container(
            alignment: Alignment.topCenter,
            width: 275,
            height: 275,
            child: Text(
              (i + 1).toString(),
              style: TextStyle(fontSize: 18),
            ),
          )));
    }
    return wigsHours;
  }

  // Run the timer and update state
  List<int> runTimer() {
    _myTimer = Timer.periodic(Duration(seconds: 1), (f) {
      setState(() {
        print(_countSec);
        _counters.clear();

        if (_countSec == 59) {
          _turnerSec = 0.0;
          _countMin++;
          _turnerMin += _angle60;
          _countSec = 0;
        } else {
          _turnerSec += _angle60;
          _countSec++;
        }
        if (_countMin == 60) {
          _turnerMin = 0.0;
          _countHour++;
          _turnerHour += _anglehour;
          _countMin = 0;
        }
        if (_countHour == 11) {
          _turnerHour = 0.0;
          _countHour = 0;
        }
        _counters.add(_countSec);
        _counters.add(_countMin);
        _counters.add(_countHour);
      });
    });
    return _counters;
  }
}
