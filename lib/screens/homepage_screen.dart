import 'package:eathlete/blocs/goal_update/goal_update_bloc.dart';
import 'package:eathlete/blocs/goals/goals_bloc.dart';
import 'package:eathlete/blocs/graph/graph_bloc.dart';
import 'package:eathlete/blocs/objective_update/objective_update_bloc.dart';
import 'package:eathlete/common_widgets/goal_widgets.dart';
import 'package:eathlete/common_widgets/objective_widgets.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/class_definitions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';

import 'goals.dart';

class HomePage extends StatelessWidget {
  static const String id = 'diary page';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          GoalUpdateBloc(Provider.of<UserRepository>(context, listen: false)),
      child: BlocProvider(
        create: (BuildContext context) => GraphBloc(
            userRepository:
                Provider.of<UserRepository>(context, listen: false)),
        child: HomePageContent(
          userRepository: Provider.of<UserRepository>(context, listen: false),
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final UserRepository userRepository;

  HomePageContent({this.userRepository});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

Box diaryBox = Hive.box('diaryBox');
double sliderDouble = 5.0;

class _HomePageContentState extends State<HomePageContent> {
  bool buttonVisible = false;
  TextEditingController controller = TextEditingController();
  List<PopupMenuItem> dropDownButtons = [
    PopupMenuItem(
      value: 'Intensity',
      child: Text('Intensity'),
    ),
    PopupMenuItem(
      value: 'Performance',
      child: Text('Performance'),
    ),
    PopupMenuItem(
      value: 'Feeling',
      child: Text('Feeling'),
    ),
    PopupMenuItem(
      value: 'Rest',
      child: Text('Rest'),
    ),
    PopupMenuItem(
      value: 'Nutrition',
      child: Text('Nutrition'),
    ),
    PopupMenuItem(
      value: 'Concentration',
      child: Text('Concentration'),
    ),
    PopupMenuItem(
      value: 'None',
      child: Text('None'),
    ),
  ];
  var _value = 'Intensity';
  var _value1 = 'Performance';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(diaryBox.get('shortTermGoals'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphBloc, GraphState>(
        builder: (BuildContext context, GraphState state) {
      DateTimeAxis xAxis = DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        maximum: currentDay,
//          visibleMaximum: state.limits[1],
//          visibleMinimum: state.limits[0]
      );
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: ImageIcon(
              AssetImage('images/menu_icon@3x.png'),
              color: Color(0xff828289),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
              setState(() {});
            },
          ),
          elevation: 1,
          actions: <Widget>[NotificationButton()],
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  height: 50,
                  child: Image.asset(
                    'images/51012169_padded_logo.png',
                    scale: 2,
                  )),
              Text(
                'E-Athlete',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
          },
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    ProfilePhoto(
                      size: 60,
                      photo: Provider.of<UserRepository>(context)
                                  .user
                                  .profilePhoto !=
                              null
                          ? NetworkImage(Provider.of<UserRepository>(context)
                              .user
                              .profilePhoto)
                          : AssetImage('images/anon-profile-picture.png'),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1.0, color: Color(0xffbec2c9)),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                controller: controller,
                                style: TextStyle(fontSize: 13),
                                decoration: InputDecoration.collapsed(
                                    hintText:
                                        'What would you like to achieve today, ${Provider.of<UserRepository>(context).user.firstName}?'),
                                onChanged: (value) {
                                  if (value != null && value != '')
                                    buttonVisible = true;
                                  else
                                    buttonVisible = false;
                                  BlocProvider.of<GoalUpdateBloc>(context)
                                      .add(UpdateGoalContent(value));
                                  setState(() {});
                                },
                              ),
                            ),
                          )),
                    )),
                    buttonVisible
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.blue,
                            onPressed: () {
                              BlocProvider.of<GoalUpdateBloc>(context)
                                  .add(SubmitFromHomePage());
                              controller.clear();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus &&
                                  currentFocus.focusedChild != null) {
                                currentFocus.focusedChild.unfocus();
                              }
                              buttonVisible = false;
                              setState(() {});
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  HomePageStatusButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider(
                                create: (BuildContext context) =>
                                    ObjectiveUpdateBloc(
                                        objectiveType: 'Intensity',
                                        userRepository:
                                            Provider.of<UserRepository>(context,
                                                listen: false)),
                                child:
                                    ObjectivePopUp(objectiveType: 'Intensity'));
                          });
                      setState(() {});
                    },
                    backgroundColor: Color(0xffecf8ea),
                    circleColor: Color(0xffa9e1a0),
                    image: Image.asset(
                      'images/weight.png',
                      width: 20,
                    ),
                    text: 'Intensity',
                    textColor: Color(0xff17af00),
                  ),
                  HomePageStatusButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider(
                                create: (BuildContext context) =>
                                    ObjectiveUpdateBloc(
                                        objectiveType: 'Hours Worked',
                                        userRepository:
                                            Provider.of<UserRepository>(context,
                                                listen: false)),
                                child: ObjectivePopUp(
                                  objectiveType: 'Hours Worked',
                                ));
                          });
                      setState(() {});
                    },
                    text: 'Hours Worked',
                    textColor: Color(0xff2179f4),
                    backgroundColor: Color(0xffe7f1fe),
                    circleColor: Color(0xff84b6fb),
                    image: Image.asset(
                      'images/hours_clock.png',
                      width: 20,
                    ),
                  ),
                  HomePageStatusButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider(
                                  create: (BuildContext context) =>
                                      ObjectiveUpdateBloc(
                                          objectiveType: 'Performance',
                                          userRepository:
                                              Provider.of<UserRepository>(
                                                  context,
                                                  listen: false)),
                                  child: ObjectivePopUp(
                                    objectiveType: 'Performance',
                                  ));
                            });
                        setState(() {});
                      },
                      textColor: Color(0xfff5542a),
                      text: 'Performance',
                      backgroundColor: Color(0xfffdece7),
                      circleColor: Color(0xfff5a895),
                      image: Image.asset(
                        'images/performance_indicator.png',
                        width: 20,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 12),
                child: Text(
                  'This Week in Numbers',
                  style: GoogleFonts.varelaRound(
                      textStyle: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   height: 120,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: <Widget>[
              //       IntensityCard(),
              //       HoursWorkedCard(),
              //       PerformanceCard(),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '--',
                              style:
                              TextStyle(fontSize: 30, color: Colors.grey),
                            ),
                            Text(
                              'Sessions completed this week',
                              style:
                              TextStyle(fontSize: 9, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '3/5',
                              style:
                              TextStyle(fontSize: 30, color: Colors.grey),
                            ),
                            Text(
                              'Planned sessions completed this week',
                              style:
                              TextStyle(fontSize: 9, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  diaryBox.get('shortTermGoals').isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 12),
                              child: Text(
                                'Today\'s Goal',
                                style: GoogleFonts.varelaRound(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                )),
                              ),
                            ),
                            HomePageGoalTile(
                                goal: diaryBox.get('shortTermGoals').first,
                                onTap: () {
                                  Provider.of<PageNumber>(context,
                                          listen: false)
                                      .pageNumber = 6;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              create: (context) => GoalsBloc(
                                                  userRepository: Provider.of<
                                                          UserRepository>(
                                                      context,
                                                      listen: false)),
                                              child: Goals())),
                                      (route) => false);
                                })
                          ],
                        )
                      : Container(),
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
//                        image: DecorationImage(
//                            image: AssetImage('images/bg_img@3x.png'),
//                            fit: BoxFit.cover)
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image(
                                      image:
                                          AssetImage('images/mystats_icon.png'),
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('My Stats',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 110,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Color(0xff4281b5))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        child: PopupMenuButton(
                                          itemBuilder: (context) {
                                            return dropDownButtons;
                                          },
                                          initialValue: '$_value',
                                          onSelected: (value) {
                                            setState(() {
                                              _value = value;
                                              BlocProvider.of<GraphBloc>(
                                                      context)
                                                  .add(ChangeGraph1(value));
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Spacer(),
                                              Text(
                                                _value,
                                                style: TextStyle(
                                                    color: Color(0xff4281b5),
                                                    fontSize: 10),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PopupMenuButton(
                                        itemBuilder: (context) {
                                          return dropDownButtons;
                                        },
                                        initialValue: '$_value1',
                                        onSelected: (value) {
                                          setState(() {
                                            _value1 = value;
                                            BlocProvider.of<GraphBloc>(context)
                                                .add(ChangeGraph2(value));
                                          });
                                        },
                                        child: Container(
                                          width: 110,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Color(0xfff43e30))),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Text(
                                                    '$_value1',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xfff43e30)),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: SfCartesianChart(
                                primaryYAxis: NumericAxis(
                                    majorGridLines: MajorGridLines(
                                        color: Color(0xffe8e8e8),
                                        dashArray: [20, 10],
                                        width: 3),
                                    minimum: 0.0,
                                    maximum: 10.05),
                                zoomPanBehavior: ZoomPanBehavior(
                                    enablePinching: true,
                                    enablePanning: true,
                                    zoomMode: ZoomMode.x),
                                primaryXAxis: xAxis,
                                series: <ChartSeries>[
                              SplineSeries<GraphObject, DateTime>(
                                dataSource: state.dataList1,
                                xValueMapper: (GraphObject graphObject, _) =>
                                    graphObject.xAxis,
                                yValueMapper: (GraphObject graphObject, _) =>
                                    graphObject.yAxis.toDouble(),
                                splineType: SplineType.monotonic,
                              ),
                              SplineSeries<GraphObject, DateTime>(
                                color: Colors.red,
                                dataSource: state.dataList2,
                                splineType: SplineType.monotonic,
                                xValueMapper: (GraphObject graphObject, _) =>
                                    graphObject.xAxis,
                                yValueMapper: (GraphObject graphObject, _) =>
                                    graphObject.yAxis,
                              ),
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      );
    });
  }
}
