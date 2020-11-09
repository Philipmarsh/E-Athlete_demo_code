//import 'package:eathlete/common_widgets/common_widgets.dart';
//import 'package:eathlete/common_widgets/goal_widgets.dart';
//import 'package:eathlete/misc/user_repository.dart';
//import 'package:eathlete/models/goal_model.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//
//
//class FinishedGoals extends StatefulWidget {
//  @override
//  _FinishedGoalsState createState() => _FinishedGoalsState();
//}
//
////FinishedObjectiveList()
//class _FinishedGoalsState extends State<FinishedGoals> with TickerProviderStateMixin{
//  List<Widget> _children = [FinishedGoalList(),];
//  TabController tabController;
//  int _currentIndex = 0;
//
//  void onTabTapped(int index) {
//    setState(() {
//      _currentIndex = index;
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    tabController = TabController(
//      vsync: this,
//      length: 1,
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      appBar: AppBar(
//        elevation: 1,
//        backgroundColor: Colors.white,
//        title: Row(
//          children: <Widget>[
//            Container(
//                height: 50, child: Image.asset('images/placeholder_logo.PNG')),
//            Text(
//              'E-Athlete',
//              style:
//              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//            )
//          ],
//        ),
//        bottom:  TabBar(
//          indicatorWeight: 2,
//          indicatorSize: TabBarIndicatorSize.label,
//          labelColor: Color(0xff23232f),
//          labelStyle: TextStyle(fontSize: 10),
//          unselectedLabelColor: Colors.grey,
//          controller: tabController,
//          onTap: onTabTapped,
//          tabs: <Widget>[
//            Tab(
//              text: 'Goals',
//            ),
//            Tab(
//              text: 'Objectives',
//            ),
//          ],
//        ),
//      ),
//      body:TabBarView(
//        children: _children,
//        controller: tabController,
//      )
//    );
//  }
//}
//
//
//class FinishedGoalList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    List<Goal> finishedGoals= Provider.of<UserRepository>(context, listen:false).diary.finishedGoals;
//    return  ListView(
//      children: <Widget>[
//        for(Goal goal in finishedGoals)GoalCard(goal)
//      ],
//    );
//  }
//}
//
//class FinishedObjectiveList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    List<Goal> finishedGoals= Provider.of<UserRepository>(context, listen:false).diary.finishedGoals;
//    return  ListView(
//      children: <Widget>[
//        for(Goal goal in finishedGoals)GoalCard(goal)
//      ],
//    );
//  }
//}

