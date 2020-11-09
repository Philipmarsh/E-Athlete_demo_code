
import 'package:eathlete/blocs/competition/competition_bloc.dart';
import 'package:eathlete/blocs/general_day/general_day_bloc.dart';
import 'package:eathlete/blocs/result/result_bloc.dart';
import 'package:eathlete/blocs/session/session_bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/Result_update_body.dart';
import 'package:eathlete/screens/competition_entry.dart';
import 'package:eathlete/screens/general_day_update.dart';
import 'package:eathlete/screens/session_update_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../misc/user_repository.dart';


class GeneralDayEntry extends StatefulWidget {
  final Function onDelete;
  final GeneralDay generalDay;
  final int index;
  const GeneralDayEntry({
    this.generalDay,
    this.onDelete,
    this.index,
    Key key,
  }) : super(key: key);

  @override
  _GeneralDayEntryState createState() => _GeneralDayEntryState();
}

class _GeneralDayEntryState extends State<GeneralDayEntry> {
  DateTime generalDayDate;
  String formattedDate;
  List<PopupMenuItem> menuItems = [
    PopupMenuItem(
      value: 'Edit',
      child: Text('Edit'),
    ),
    PopupMenuItem(value: 'Delete', child: Text('Delete'))
  ];

  @override
  void initState() {
    super.initState();
    generalDayDate = DateTime.parse(widget.generalDay.date);
    formattedDate =
        '${timeToString(generalDayDate.day)}/${timeToString(generalDayDate.month)}/${generalDayDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 16,
                            width: 16,
                            child: Center(
                                child: Icon(
                              Icons.calendar_today,
                              size: 13,
                            )),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0.5,
                                      blurRadius: 1,
                                      color: Colors.grey)
                                ],
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'General Day',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.generalDay.date == null
                                ? '-'
                                : formattedDate,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          PopupMenuButton(
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (BuildContext context) {
                              return menuItems;
                            },
                            onSelected: (value) {
                              if (value == 'Edit') {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return BlocProvider(
                                          create: (context) => GeneralDayBloc(
                                              Provider.of<UserRepository>(
                                                  context,
                                                  listen: false),
                                              generalDay: widget.generalDay),
                                          child: SafeArea(
                                              child: SingleChildScrollView(
                                                  child:
                                                      GeneralDayUpdateBody())));
                                    });
                              } else if (value == 'Delete') {
                                widget.generalDay.addToDeleteQueue();
                                print(widget.index);
                                widget.onDelete();
                                processDeleteQueue(Provider.of<UserRepository>(context, listen: false));
                                // Provider.of<UserRepository>(context,
                                //         listen: false)
                                //     .diary
                                //     .generalDayList
                                //     .remove(widget.generalDay);
                                try {
                                  AnimatedList.of(context).removeItem(
                                      widget.index,
                                      (context, animation) => Container());
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'I feel well rested',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text(widget.generalDay.rested == null
                            ? '-'
                            : '${widget.generalDay.rested}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'I have eaten well today',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text(widget.generalDay.nutrition == null
                            ? '-'
                            : '${widget.generalDay.nutrition}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Concentration throughout day',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text(widget.generalDay.concentration == null
                            ? '-'
                            : '${widget.generalDay.concentration}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Reflections',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(widget.generalDay.reflections == null
                            ? '-'
                            : widget.generalDay.reflections)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompetitionDiaryEntry extends StatefulWidget {
  final Competition _competition;
  final int index;
  final Function onDelete;
  CompetitionDiaryEntry(this._competition, {this.onDelete, this.index});

  @override
  _CompetitionDiaryEntryState createState() => _CompetitionDiaryEntryState();
}

class _CompetitionDiaryEntryState extends State<CompetitionDiaryEntry> {
  DateTime competitionDate;
  String formattedDate;

  List<PopupMenuItem> menuItems = [
    PopupMenuItem(
      value: 'Edit',
      child: Text('Edit'),
    ),
    PopupMenuItem(value: 'Delete', child: Text('Delete'))
  ];

  @override
  void initState() {
    super.initState();
    competitionDate = DateTime.parse(widget._competition.date);
    formattedDate =
        '${timeToString(competitionDate.day)}/${timeToString(competitionDate.month)}/${competitionDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 16,
                        width: 16,
                        child: Center(
                            child: Icon(
                          Icons.calendar_today,
                          size: 13,
                        )),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 1,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget._competition.name == null
                            ? '-'
                            : widget._competition.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget._competition.date == null ? '-' : formattedDate,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                      ),
                      PopupMenuButton(
                        child: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) {
                          return menuItems;
                        },
                        onSelected: (value) {
                          if (value == 'Edit') {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (builder) {
                                  return BlocProvider(
                                      create: (context) => CompetitionBloc(
                                          Provider.of<UserRepository>(context,
                                              listen: false),
                                          competition: widget._competition),
                                      child: SafeArea(
                                          child: SingleChildScrollView(
                                              child: CompetitionEntry())));
                                });
                          } else if (value == 'Delete') {
                            widget._competition.addToDeleteQueue();
                            widget.onDelete();
                            processDeleteQueue(Provider.of<UserRepository>(context, listen: false));
                            try {
                              AnimatedList.of(context)
                                  .removeItem(0, (context, animation) => null);
                            } catch (e) {
                              print('Not in an animated list');
                            }
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Start Time',
                      style: TextStyle(color: Color(0xff828289)),
                    ),
                    Text(widget._competition.startTime == null
                        ? '-'
                        : '${widget._competition.startTime.substring(0, 5)}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Address',
                      style: TextStyle(color: Color(0xff828289)),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(widget._competition.address == null
                        ? '-'
                        : widget._competition.address),
                    SizedBox(
                      height: 8,
                    ),
                    DateTime.parse(widget._competition.date)
                            .isBefore(DateTime.now())
                        ? FlatButton(
                            child: Text(
                              'Convert into Result',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (builder) {
                                    return BlocProvider(
                                        create: (context) => ResultBloc(
                                            Provider.of<UserRepository>(context,
                                                listen: false),
                                            competition: widget._competition,
                                            isCompetitionConverter: true,
                                            result: Result(
                                                date: widget._competition.date,
                                                name:
                                                    widget._competition.name)),
                                        child: ResultUpdateBody());
                                  });
                            },
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionEntry extends StatefulWidget {
  final Session session;
  final Function onDelete;
  final int index;
  const SessionEntry({
    @required this.session,
    this.index,
    this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  _SessionEntryState createState() => _SessionEntryState();
}

class _SessionEntryState extends State<SessionEntry> {
  DateTime sessionDate;
  String formattedDate;

  List<PopupMenuItem> menuItems = [
    PopupMenuItem(
      value: 'Edit',
      child: Text('Edit'),
    ),
    PopupMenuItem(value: 'Delete', child: Text('Delete'))
  ];

  @override
  void initState() {
    super.initState();
    sessionDate = DateTime.parse(widget.session.date);
    formattedDate =
        '${timeToString(sessionDate.day)}/${timeToString(sessionDate.month)}/${sessionDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(children: <Widget>[
          Container(
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.blue),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                            Icons.hourglass_empty,
                            size: 13,
                          )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.session.title?? 'Session',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          formattedDate,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return menuItems;
                            },
                            onSelected: (value) {
                              if (value == 'Edit') {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return BlocProvider(
                                          create: (context) => SessionBloc(
                                              Provider.of<UserRepository>(
                                                  context,
                                                  listen: false),
                                              session: widget.session),
                                          child: SafeArea(
                                              child: SingleChildScrollView(
                                                  child:
                                                      SessionUpdateScreen())));
                                    });
                              } else if (value == 'Delete') {
                                widget.session.addToDeleteQueue();
                                widget.onDelete();
                                processDeleteQueue(Provider.of<UserRepository>(context, listen: false));
                                try {
                                  AnimatedList.of(context).removeItem(
                                      widget.index,
                                      (context, animation) => Container());
                                } catch (e) {
                                  print('Not in Animated List');
                                }
                              }
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Intensity of Session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text('${widget.session.intensity}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Performance in session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text('${widget.session.performance}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Length of session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget.session.lengthOfSession == null
                          ? '-'
                          : '${widget.session.lengthOfSession}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Feeling Scale',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget.session.feeling),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Targets for the session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(widget.session.target == null
                          ? '-'
                          : widget.session.target)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reflections on the session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(widget.session.reflections == null
                          ? '-'
                          : widget.session.reflections)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class ResultEntry extends StatefulWidget {
  final Function onDelete;
  final Result result;
  final int index;
  const ResultEntry({
    this.result,
    this.onDelete,
    this.index,
    Key key,
  }) : super(key: key);

  @override
  _ResultEntryState createState() => _ResultEntryState();
}

class _ResultEntryState extends State<ResultEntry> {
  DateTime resultDate;
  String formattedDate;
  List<PopupMenuItem> menuItems = [
    PopupMenuItem(
      value: 'Edit',
      child: Text('Edit'),
    ),
    PopupMenuItem(value: 'Delete', child: Text('Delete'))
  ];

  @override
  void initState() {
    super.initState();
    resultDate = DateTime.parse(widget.result.date);
    formattedDate =
        '${timeToString(resultDate.day)}/${timeToString(resultDate.month)}/${resultDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 16,
                            width: 16,
                            child: Center(
                                child: Icon(
                              Icons.calendar_today,
                              size: 13,
                            )),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0.5,
                                      blurRadius: 1,
                                      color: Colors.grey)
                                ],
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.result.name == null
                                ? 'Result'
                                : widget.result.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.result.date == null ? '-' : formattedDate,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return menuItems;
                            },
                            onSelected: (value) {
                              if (value == 'Edit') {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return BlocProvider(
                                          create: (context) => ResultBloc(
                                              Provider.of<UserRepository>(
                                                  context,
                                                  listen: false),
                                              result: widget.result),
                                          child: SafeArea(
                                              child: SingleChildScrollView(
                                                  child: ResultUpdateBody())));
                                    });
                              } else if (value == 'Delete') {
                                widget.result.addToDeleteQueue();
                                widget.onDelete();
                                processDeleteQueue(Provider.of<UserRepository>(context, listen: false));
                                // Provider.of<UserRepository>(context,
                                //         listen: false)
                                //     .diary
                                //     .resultList
                                //     .remove(widget.result);
                                try {
                                  AnimatedList.of(context).removeItem(
                                      widget.index,
                                      (context, animation) => Container());
                                } catch (e) {
                                  print('Not in an animatedList');
                                }
                              }
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Position',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text(widget.result.position == null
                            ? '-'
                            : '${widget.result.position}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Reflections',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(widget.result.reflections == null
                            ? '-'
                            : widget.result.reflections)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
