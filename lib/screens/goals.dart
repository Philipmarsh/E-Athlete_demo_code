import 'package:eathlete/blocs/goal_update/goal_update_bloc.dart';
import 'package:eathlete/blocs/goals/goals_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/common_widgets/goal_widgets.dart';
import 'package:eathlete/graph_data/goals_graphs.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/screens/goal_update_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';




class Goals extends StatefulWidget {
  Goals({Key key}) : super(key: key);

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> with TickerProviderStateMixin {

  LinkedScrollControllerGroup _controllers;
  ScrollController _wholePageController;
  ScrollController _bottomOfPageController;

  TabController tabController;
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _wholePageController = _controllers.addAndGet();
    _bottomOfPageController = _controllers.addAndGet();
    tabController = TabController(
      vsync: this,
      length: 4,
    );
  }

  @override
  void dispose() {
    _wholePageController.dispose();
    _bottomOfPageController.dispose();
    super.dispose();
  }

  List<Widget> mediumTermGoalsTiles;
  List<Widget> dailyGoalsTiles;
  List<Widget> crazyGoalsTiles;
  List<Widget> finishedGoalsTiles;
  @override
  Widget build(BuildContext context) {
    UserRepository _userRepository =
        Provider.of<UserRepository>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: Hive.box('diaryBox').listenable(),
      builder: (context, box, widget) {
        return Scaffold(
          drawer: EAthleteDrawer(),
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: ImageIcon(
                    AssetImage('images/menu_icon@3x.png'),
                    color: Color(0xff828289),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
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
          floatingActionButton: SpeedDial(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            animatedIcon: AnimatedIcons.menu_close,
            shape: CircleBorder(),
            children: <SpeedDialChild>[
              SpeedDialChild(
                child: Icon(Icons.calendar_today),
                backgroundColor: Colors.blue[500],
                foregroundColor: Colors.white,
                label: 'Short Term Goal',
                onTap: () {
                  print('Top Button Pressed');
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider(
                          create: (context) => GoalUpdateBloc(
                              Provider.of<UserRepository>(context, listen: false),
                              goalType: 'Short Term'),
                          child: GoalUpdateBody(),
                        );
                      });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.assessment),
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
                label: 'Medium Term Goal',
                onTap: () {
                  print('Top Button Pressed');
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider(
                          create: (context) => GoalUpdateBloc(
                              Provider.of<UserRepository>(context, listen: false),
                              goalType: 'Medium Term'),
                          child: GoalUpdateBody(),
                        );
                      });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.timeline),
                backgroundColor: Colors.blue[200],
                foregroundColor: Colors.white,
                label: 'Long Term Goal',
                onTap: () {
                  print('Top Button Pressed');
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider(
                          create: (context) => GoalUpdateBloc(
                              Provider.of<UserRepository>(context, listen: false),
                              goalType: 'Long Term'),
                          child: GoalUpdateBody(),
                        );
                      });
                },
              ),
              box.get('ultimateGoal').length == 0
                  ? SpeedDialChild(
                child: Icon(Icons.stars),
                backgroundColor: Colors.blue[200],
                foregroundColor: Colors.white,
                label: 'Ultimate Goal',
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider(
                          create: (context) => GoalUpdateBloc(
                              Provider.of<UserRepository>(context,
                                  listen: false),
                              goalType: 'Ultimate'),
                          child: GoalUpdateBody(),
                        );
                      });
                },
              )
                  : SpeedDialChild(
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
          body:
          Container(
            child: CustomScrollView(
              controller: _wholePageController,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Goal Setting',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Container(
                                    height: 100,
                                    width: 250,
                                    child: GoalsAchievedGraph(_userRepository)
                                ),
                              ),
                            ),
                            CrazyGoalCountdown(),
                          ],
                        ),
                      ),
                      box.get('ultimateGoal').length != 0
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text('Ultimate Goal'),
                                Spacer(),
                              ],
                            ),
                          ),
                          UltimateGoalCard(
                            goal: box.get('ultimateGoal')[0],
                            onAchievedPressed: () {
                              BlocProvider.of<GoalsBloc>(context).add(
                                  GoalAchieved(
                                     box.get('ultimateGoal')[0]));
                              setState(() {});
                            },
                            onNotAchievedPressed: () {
                              BlocProvider.of<GoalsBloc>(context).add(
                                  GoalNotAchieved(
                                      box.get('ultimateGoal')[0]));
                              setState(() {});
                            },
                            onShortPressed: () {
                              BlocProvider.of<GoalsBloc>(context).add(
                                  ChangeGoalsList(
                                      box.get('ultimateGoal')[0],
                                      'Short Term'));
                              setState(() {});
                            },
                            onMediumPressed: () {
                              BlocProvider.of<GoalsBloc>(context).add(
                                  ChangeGoalsList(
                                     box.get('ultimateGoal')[0],
                                      'Medium Term'));
                              setState(() {});
                            },
                            onLongPressed: () {
                              BlocProvider.of<GoalsBloc>(context).add(
                                  ChangeGoalsList(
                                      box.get('ultimateGoal')[0],
                                      'Long Term'));
                              setState(() {});
                            },
                            onDeletePressed: () {
                              BlocProvider.of<GoalsBloc>(context).add(GoalDeleted(
                                 box.get('ultimateGoal')[0]));
                              setState(() {});
                            },
                          ),
                        ],
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Secondary Goals'),
                      ),
                      TabBar(
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Color(0xff23232f),
                          labelStyle: TextStyle(fontSize: 10),
                          unselectedLabelColor: Colors.grey,
                          controller: tabController,
                          onTap: onTabTapped,
                          tabs: <Widget>[
                            Tab(
                              text: 'Short',
                            ),
                            Tab(
                              text: 'Medium',
                            ),
                            Tab(
                              text: 'Long',
                            ),
                            Tab(
                              text: 'Finished',
                            ),
                          ]),
                    ])),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: TabBarView(children:
                  <Widget>[
                    ShortTermList(scrollController: _bottomOfPageController,),
                    MediumTermList(scrollController: _bottomOfPageController,),
                    LongTermList(scrollController: _bottomOfPageController,),
                    FinishedList(scrollController: _bottomOfPageController,)
                  ], controller: tabController),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CrazyGoalCountdown extends StatelessWidget {
  CrazyGoalCountdown({
    Key key,
  }) :
        super(key: key);
  final Box diaryBox = Hive.box('diaryBox');

  @override
  Widget build(BuildContext context) {
    DateTime setOnDate;
    DateTime deadlineDate;
    Duration difference;
    Duration timeSinceSet;
    double percentage;
    if (diaryBox.get('ultimateGoal').length > 0) {
      setOnDate =
          DateTime.parse(diaryBox.get('ultimateGoal').last.setOnDate);
      deadlineDate =
          DateTime.parse(diaryBox.get('ultimateGoal').last.deadlineDate);
      difference = deadlineDate.difference(setOnDate);

      timeSinceSet = DateTime.now().difference(setOnDate);
      if (difference.inDays == 0)
        percentage = 100;
      else
        percentage = timeSinceSet.inDays / difference.inDays * 100;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Container(
          height: 100,
          width: 250,
          child: diaryBox.get('ultimateGoal').length > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        '${difference.inDays - timeSinceSet.inDays} days to achieve your goal of:'),
                    Text('${diaryBox.get('ultimateGoal').last.content}'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 10,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 10,
                            width: percentage,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(40)),
                          ),
                          Spacer()
                        ],
                      ),
                    )
                  ],
                )
              : Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'No Ultimate goal has been set. click below to set an ultimate goal'),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
