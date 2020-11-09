import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';


import '../common_widgets/common_widgets.dart';
import '../misc/useful_functions.dart';

class TimerPageActual extends StatefulWidget {
  static const String id = 'timer';
  @override
  _TimerPageActualState createState() => _TimerPageActualState();
}

class _TimerPageActualState extends State<TimerPageActual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      drawer: EAthleteDrawer(),
      appBar: AppBar(
        elevation: 1,
        actions: <Widget>[
          NotificationButton()
        ],
        backgroundColor: Colors.white,
        title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 50, child: Image.asset('images/placeholder_logo.PNG')),
            Text(
              'E-Athlete',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      body:TimerPage(),
    );
  }
}


class TimerPage extends StatefulWidget {

  TimerPage({Key key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeContent());
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
//  int currentTime = 0;
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;
  bool _stopwatchRunning = false;
  int _elapsedTime = 0;
//  String currentTime;

  void startTimer() {
    _stopwatch.start();

    setState(() {
      _stopwatchRunning = true;
//      currentTime =
//          '${timeToString(DateTime.now().hour)}:${timeToString(DateTime.now().minute)}';
    });
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsedMilliseconds;
      });
    });
  }

  void stopTimer() {
    _stopwatch.stop();
    setState(() {
      _stopwatchRunning = false;
    });

    _timer.cancel();
    _elapsedTime = _stopwatch.elapsedMilliseconds;
  }

  double percentage;
  @override
  void initState() {
    super.initState();
    setState(() {
      percentage = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200.0,
            width: 200.0,
            child: CustomPaint(
              foregroundPainter: OuterRing(
                  lineColor: Color(0xffe8ecef),
                  startColor: Color(0xffe8ecef),
                  endColor: Colors.blueAccent,
                  completePercent: _elapsedTime.toDouble(),
                  width: 12),
              child: CustomPaint(
                foregroundPainter: InnerRing(color: Colors.blue, width: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Total Time',
                            style: TextStyle(
                                color: Color(0xff828289), fontSize: 16),
                          ),
                          Text(
                            formatTime(_elapsedTime),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _stopwatchRunning?'Stop':'Start',
                            style: TextStyle(
                                color: Color(0xff828289), fontSize: 16,),
                            ),

//                            'Start Time',
//                            style: TextStyle(
//                                color: Color(0xff828289), fontSize: 12),
//                          ),
//                          Text(
//                            currentTime == null ? '-' : '$currentTime',
//                            style: TextStyle(fontSize: 12),
//                          )
                        ],
                      ),
                      onPressed: () {
                        if (_stopwatchRunning == false) {
                          startTimer();
                        } else if (_stopwatchRunning == true) {
                          stopTimer();
                        }
                      }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(

                onPressed: () {setState(() {
                  _stopwatch.stop();
                  _stopwatch.reset();
                  _elapsedTime = 0;
                });

                },
                textColor: Colors.white,
                color: Colors.blue,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Text('Reset'),
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(

                onPressed: () {
//
                  if (_stopwatchRunning == false) {
                    startTimer();
                  } else if (_stopwatchRunning == true) {
                    stopTimer();
                  }
                },
                textColor: Colors.white,
                color: Colors.blue,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Text('Save Time'),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();

  }
}

class OuterRing extends CustomPainter {

  /// Colour of base line.
  Color lineColor;

  /// Colour of completed section.
//  Color completeColor;

  ///colour of the dot that is centered at the front of the completed section
  Color dotColor;

  /// Double that defines progress on the timer.
  /// The decimal value describes the progress made, but value can be above 1.
  /// eg 1.5 will show the same amount of progress as 0.5.
  double completePercent;

  /// Defines width of the ring
  double width;

  final Color startColor;
  final Color endColor;

  OuterRing(
      {this.lineColor,
//      this.completeColor,
      this.completePercent,
      this.width,
        this.startColor,
        this.endColor,
      this.dotColor = Colors.white});
  @override
  void paint(Canvas canvas, Size size) {
    final double arcAngle = 2 * pi * ((completePercent ) / 60000);

    final double startPoint = arcAngle < pi -0.2? arcAngle : pi-0.2;
    Offset center = new Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = new SweepGradient(
      startAngle: (arcAngle-pi/2)+ pi +0.08, // by involving pi/2, split the circle into 4
      endAngle: (arcAngle-pi/2)+ 2*pi +0.08,  //this must be bigger than start angle at all times. try and make this equal to startangle+ 0.05
      tileMode: TileMode.repeated,
      colors: [startColor, endColor],
    );
    Paint dot = new Paint()
      ..color = dotColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width - 5;
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawCircle(center, radius, line);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), arcAngle -pi/2,
        -startPoint, false, complete);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        arcAngle - pi / 2, 0.001, false, dot);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class InnerRing extends CustomPainter {
  Color color;
  double width;

  InnerRing({this.color, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min((size.width / 2) - 16, (size.height / 2) - 16);

    double arcAngle = 0.03;
    double circumference = 2 * pi;
    double segment = circumference / 12;

    for (int i = 0; i < 12; i++) {
      canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
          segment * i - arcAngle / 2, arcAngle, false, line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
