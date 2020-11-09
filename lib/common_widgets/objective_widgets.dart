
import 'package:eathlete/blocs/objective_update/objective_update_bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';


import 'package:provider/provider.dart';

import 'common_widgets.dart';

///Button displayed under status updater, to be used with intensity, performance
///and hours worked
class HomePageStatusButton extends StatelessWidget {
  final Function onPressed;
  final Color circleColor;
  final Color backgroundColor;
  final String text;
  final Image image;
  final Color textColor;
  const HomePageStatusButton(
      {Key key,
      this.image,
      this.onPressed,
      this.backgroundColor,
      this.circleColor,
      this.text,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        width: 120,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: image,
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

///When HomePageStatusButton clicked this dialog appears
class ObjectivePopUp extends StatefulWidget {
  final String objectiveType;
  const ObjectivePopUp({
    this.objectiveType,
    Key key,
  }) : super(key: key);

  @override
  _ObjectivePopUpState createState() => _ObjectivePopUpState();
}

class _ObjectivePopUpState extends State<ObjectivePopUp> {

  @override
  Widget build(BuildContext context) {

    if (widget.objectiveType == 'Intensity') {
      return BlocListener<ObjectiveUpdateBloc, ObjectiveUpdateState>(
        listener: (BuildContext context, ObjectiveUpdateState state){
          if(state is Submitted){
            Navigator.pop(context);
          }
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              height: 400,
//          MediaQuery.of(context).size.height*0.6,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Color(0xffe9f8e8),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(image: AssetImage('images/intensity_goal_thing.png'), fit: BoxFit.cover),
                            ),),
//                            SizedBox(width: MediaQuery.of(context).size.width*0.5,),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('New Intensity Objective', style: TextStyle(color: Colors.green),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(flex: 4,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0,),
                      child: Text('Number of Days'),
                    ),
                    Spacer(flex: 1,),
                    NumberPicker(minimum: 0, maximum: 7, startValue: 0,
                      color: Colors.green,
                      onBackPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateDeadlineDate(DateTime(currentDay.year, currentDay.month, currentDay.day + value)));},
                      onForwardPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateDeadlineDate(DateTime(currentDay.year, currentDay.month, currentDay.day + value)));},),
                    Spacer(flex: 1,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Goal Average'),
                    ),
                    Spacer(flex: 1,),
                    NumberPicker(minimum: 1, maximum: 10, startValue: 1,
                      color: Colors.green,
                      onBackPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateAverage(value));},
                      onForwardPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateAverage(value));},),
                    Spacer(flex: 4,),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20, ),
                      child: FlatButton(
                        color: Color(0xffe9f8e8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          BlocProvider.of<ObjectiveUpdateBloc>(context)
                              .add(SubmitResponse());
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text('OK', style: TextStyle(color: Colors.green),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    } else if (widget.objectiveType == 'Hours Worked') {
      return BlocListener<ObjectiveUpdateBloc, ObjectiveUpdateState>(
        listener: (BuildContext context, ObjectiveUpdateState state){
          if(state is Submitted){
            Navigator.pop(context);
          }
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              height: 400,
//          MediaQuery.of(context).size.height*0.6,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Color(0xffe4f0fd),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(image: AssetImage('images/time_objective_thingy.png'), fit: BoxFit.cover),
                              ),),
//                            SizedBox(width: MediaQuery.of(context).size.width*0.5,),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('New Hours Worked Objective', style: TextStyle(color: Colors.blue),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(flex: 4,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0,),
                      child: Text('Number of Days'),
                    ),
                    Spacer(flex: 1,),
                    NumberPicker(minimum: 0, maximum: 7, startValue: 0,
                      color: Colors.blue,
                      onBackPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateDeadlineDate(DateTime(currentDay.year, currentDay.month, currentDay.day + value)));},
                      onForwardPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateDeadlineDate(DateTime(currentDay.year, currentDay.month, currentDay.day + value)));},),
                    Spacer(flex: 1,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Desired Number of Hours'),
                    ),
                    Spacer(flex: 1,),
                    NumberPicker(minimum: 0, maximum: 99, startValue: 0,
                      color: Colors.blue,
                      onBackPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateLength(value));},
                      onForwardPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateLength(value));},),
                    Spacer(flex: 4,),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20, ),
                      child: FlatButton(
                        color: Color(0xffe4f0fd),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          BlocProvider.of<ObjectiveUpdateBloc>(context)
                              .add(SubmitResponse());
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text('OK', style: TextStyle(color: Colors.blue),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    } else if (widget.objectiveType == 'Performance') {
      return BlocListener<ObjectiveUpdateBloc, ObjectiveUpdateState>(
        listener: (BuildContext context, ObjectiveUpdateState state){
          if(state is Submitted){
            Navigator.pop(context);
          }
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              height: 400,
//          MediaQuery.of(context).size.height*0.6,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Color(0xfffdebe7),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(image: AssetImage('images/performance_thing.png'), fit: BoxFit.cover),
                              ),),
//                            SizedBox(width: MediaQuery.of(context).size.width*0.5,),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('New Performance Objective', style: TextStyle(color: Colors.red),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(flex: 4,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0,),
                      child: Text('Number of Days'),
                    ),
                    Spacer(flex: 1,),
                    NumberPicker(minimum: 0, maximum: 7, startValue: 0,
                      color: Colors.red,
                      onBackPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateDeadlineDate(DateTime(currentDay.year, currentDay.month, currentDay.day + value)));},
                      onForwardPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateDeadlineDate(DateTime(currentDay.year, currentDay.month, currentDay.day + value)));},),
                    Spacer(flex: 1,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Goal Average'),
                    ),
                    Spacer(flex: 1,),
                    NumberPicker(minimum: 1, maximum: 5, startValue: 1,
                      color: Colors.red,
                      onBackPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateAverage(value));},
                      onForwardPressed: (value){BlocProvider.of<ObjectiveUpdateBloc>(context)
                          .add(UpdateAverage(value));},),
                    Spacer(flex: 4,),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20, ),
                      child: FlatButton(
                        color: Color(0xfffdebe7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          BlocProvider.of<ObjectiveUpdateBloc>(context)
                              .add(SubmitResponse());
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text('OK', style: TextStyle(color: Colors.red),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    }
  }
}



class PerformanceCard extends StatefulWidget {
  const PerformanceCard({
    Key key,
  }) : super(key: key);

  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  int desiredAverage;
  double currentAverage;
  DateTime endsOn;
  DateTime started;
  Color circleColor = Colors.green;

  /// gets current intensity objective, then calculate average from the day it
  /// was started until the end date
  void getObjectives(UserRepository _userRepository) {
    Map<DateTime, List<Session>> sessionMap = {};

    if (diaryBox.get('performanceObjective') != null) {
      endsOn = diaryBox.get('performanceObjective').endDate;
      started = diaryBox.get('performanceObjective').startDate;
      desiredAverage = diaryBox.get('performanceObjective').average;

      for (Session session in diaryBox.get('sessionList')) {
        DateTime date = DateTime.parse(session.date);
        sessionMap.update(date, (existingValue) {
          existingValue.add(session);
          return existingValue;
        }, ifAbsent: () => [session]);
      }
      int total = 0;
      int numberOfSessions = 0;
      int difference = endsOn.difference(started).inDays;

      for (var i = 0; i <= difference; i++) {
        DateTime dateTimeSteps =
            DateTime(started.year, started.month, started.day + i);

        List<Session> sessionList = sessionMap[dateTimeSteps];
        if (sessionList != null) {
          for (Session session in sessionList) {
            total += session.intensity;
            numberOfSessions++;
          }
        }
      }
      print(total);
      print(numberOfSessions);
      if(numberOfSessions != 0) {
        currentAverage = total / numberOfSessions;
      }else{
        currentAverage = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getObjectives(Provider.of<UserRepository>(context));

    if (currentAverage != null) {
      if (currentAverage >= desiredAverage)
        circleColor = Colors.green;
      else if (currentAverage < desiredAverage - 2)
        circleColor = Colors.red;
      else
        circleColor = Colors.orangeAccent;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Container(
          height: 100,
          width: 250,
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image: AssetImage('images/performance_thing.png'),
                            fit: BoxFit.cover)),
                  )),
              Expanded(
                child: diaryBox.get('PerformanceObjective') !=
                        null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Performance',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Goal: ',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                desiredAverage != null
                                    ? '$desiredAverage '
                                    : 'N/A ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Container(
                                width: 1,
                                height: 10,
                                color: Colors.grey,
                              ),
                              Text(
                                'Avg: ',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(currentAverage != null
                                  ? '${currentAverage.toString().substring(0, 3)} '
                                  : 'N/A')
                            ],
                          ),
                          Text(
                            endsOn != null
                                ? 'Ends on ${timeToString(endsOn.day)}/${timeToString(endsOn.month)}/${endsOn.year}'
                                : 'Ends on N/A',
                            style: TextStyle(fontSize: 9),
                          )
                        ],
                      )
                    : Text('No Objective set yet'),
              ),
              diaryBox.get('performanceObjective') !=
                      null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: circleColor),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class HoursWorkedCard extends StatefulWidget {
  const HoursWorkedCard({
    Key key,
  }) : super(key: key);

  @override
  _HoursWorkedCardState createState() => _HoursWorkedCardState();
}

class _HoursWorkedCardState extends State<HoursWorkedCard> {
  Box diaryBox = Hive.box('diaryBox');
  int desiredNumberOfHours;
  int currentNumberOfMinutes = 0;
  String currentNumberOfHours;
  DateTime endsOn;
  DateTime started;
  Color circleColor;

  /// gets current intensity objective, then calculate average from the day it
  /// was started until the end date
  void getObjectives(UserRepository _userRepository) {
    Map<DateTime, List<Session>> sessionMap = {};
    currentNumberOfMinutes = 0;
    if (diaryBox.get('hoursWorkedObjective') != null) {
      endsOn = diaryBox.get('hoursWorkedObjective').endDate;
      started = diaryBox.get('hoursWorkedObjective').startDate;
      desiredNumberOfHours =
          diaryBox.get('hoursWorkedObjective').hoursOfWork;

      for (Session session in diaryBox.get('sessionList')) {
        DateTime date = DateTime.parse(session.date);
        sessionMap.update(date, (existingValue) {
          existingValue.add(session);
          return existingValue;
        }, ifAbsent: () => [session]);
      }

      int difference = endsOn.difference(started).inDays;

      for (var i = 0; i <= difference; i++) {
        DateTime dateTimeSteps =
            DateTime(started.year, started.month, started.day + i);

        List<Session> sessionList = sessionMap[dateTimeSteps];
        if (sessionList != null) {
          for (Session session in sessionList) {
            if (session.lengthOfSession != null) {
              currentNumberOfMinutes += session.lengthOfSession;
            }
          }
        }
      }
      currentNumberOfHours = (currentNumberOfMinutes / 60).toStringAsFixed(1);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getObjectives(Provider.of<UserRepository>(context, listen: false));
    if(diaryBox.get('hoursWorkedObjective') !=
        null){if (currentNumberOfMinutes / 60 >= desiredNumberOfHours)
      circleColor = Colors.green;
    else if (currentNumberOfMinutes / 60 < desiredNumberOfHours - 2)
      circleColor = Colors.red;
    else
      circleColor = Colors.orangeAccent;}
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Container(
          height: 100,
          width: 250,
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image:
                                AssetImage('images/time_objective_thingy.png'),
                            fit: BoxFit.cover)),
                  )),
              Expanded(
                child: diaryBox.get('hoursWorkedObjective') !=
                        null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 7,),
                              Expanded(
                                child: Text(
                                  'Hours Worked',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Goal: ',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                desiredNumberOfHours != null
                                    ? '$desiredNumberOfHours '
                                    : 'N/A ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Container(
                                width: 1,
                                height: 10,
                                color: Colors.grey,
                              ),
                              Text(
                                'now: ',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(currentNumberOfHours != null
                                  ? '$currentNumberOfHours '
                                  : 'N/A ')
                            ],
                          ),
                          Text(
                            endsOn != null
                                ? 'Ends on ${timeToString(endsOn.day)}/${timeToString(endsOn.month)}/${endsOn.year}'
                                : 'Ends on N/A',
                            style: TextStyle(fontSize: 9),
                          )
                        ],
                      )
                    : Text('No Objective set yet'),
              ),
              diaryBox.get('hoursWorkedObjective') !=
                      null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: circleColor),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class IntensityCard extends StatefulWidget {
  const IntensityCard({
    Key key,
  }) : super(key: key);

  @override
  _IntensityCardState createState() => _IntensityCardState();
}

class _IntensityCardState extends State<IntensityCard> {
  int desiredAverage;
  double currentAverage;
  DateTime endsOn;
  DateTime started;
  Color circleColor;

  /// gets current intensity objective, then calculate average from the day it
  /// was started until the end date
  void getObjectives(UserRepository _userRepository) {
    Map<DateTime, List<Session>> sessionMap = {};

    if (diaryBox.get('intensityObjective') != null) {
      endsOn = diaryBox.get('intensityObjective').endDate;
      started = diaryBox.get('intensityObjective').startDate;
      desiredAverage = diaryBox.get('intensityObjective').average;

      for (Session session in diaryBox.get('sessionList')) {
        DateTime date = DateTime.parse(session.date);
        sessionMap.update(date, (existingValue) {
          existingValue.add(session);
          return existingValue;
        }, ifAbsent: () => [session]);
      }
      int total = 0;
      int numberOfSessions = 0;
      int difference = endsOn.difference(started).inDays;

      for (var i = 0; i <= difference; i++) {
        DateTime dateTimeSteps =
            DateTime(started.year, started.month, started.day + i);

        List<Session> sessionList = sessionMap[dateTimeSteps];
        if (sessionList != null) {
          for (Session session in sessionList) {
            total += session.intensity;
            numberOfSessions++;
          }
        }
      }
      print(total);
      print(numberOfSessions);
      if(numberOfSessions != 0) {
        currentAverage = total / numberOfSessions;
      }else{
        currentAverage = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getObjectives(Provider.of<UserRepository>(context, listen: false));
    if(diaryBox.get('intensityObjective')!=
        null){if (currentAverage >= desiredAverage)
      circleColor = Colors.green;
    else if (currentAverage < desiredAverage - 2)
      circleColor = Colors.red;
    else
      circleColor = Colors.orangeAccent;}

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Container(
          height: 100,
          width: 250,
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image:
                                AssetImage('images/intensity_goal_thing.png'),
                            fit: BoxFit.cover)),
                  )),
              Expanded(
                child: diaryBox.get('intensityObjective') !=
                        null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Intensity',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Goal: ',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                desiredAverage != null
                                    ? '$desiredAverage '
                                    : 'N/A ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Container(
                                width: 1,
                                height: 10,
                                color: Colors.grey,
                              ),
                              Text(
                                'Avg: ',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(currentAverage != null
                                  ? '${currentAverage.toString().substring(0, 3)} '
                                  : 'N/A ')
                            ],
                          ),
                          Text(
                            endsOn != null
                                ? 'Ends on ${timeToString(endsOn.day)}/${timeToString(endsOn.month)}/${endsOn.year}'
                                : 'Ends on N/A',
                            style: TextStyle(fontSize: 9),
                          )
                        ],
                      )
                    : Text('No Objective set yet'),
              ),
              diaryBox.get('intensityObjective') !=
                      null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: circleColor),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class FinishedObjectiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(),
    );
  }
}

