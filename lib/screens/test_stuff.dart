import 'package:eathlete/blocs/goals/goals_bloc.dart';
import 'package:eathlete/common_widgets/goal_widgets.dart';
import 'package:eathlete/graph_data/goals_graphs.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'goals.dart';

// class NewList extends StatefulWidget {
//   @override
//   _NewListState createState() => _NewListState();
// }
//
// class _NewListState extends State<NewList> with TickerProviderStateMixin {
//
//
//   List<Widget> _children = [
//     ShortTermList(),
//     MediumTermList(),
//     LongTermList(),
//     FinishedList()
//   ];
//
//   TabController tabController;
//   int _currentIndex = 0;
//
//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(
//       vsync: this,
//       length: 4,
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     UserRepository _userRepository =
//     Provider.of<UserRepository>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverList(
//               delegate:  SliverChildListDelegate(
//                 [
//                 Padding(
//                 padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Goal Setting',
//               style: TextStyle(fontSize: 20),
//             ),
//
//           ],
//         ),
//       ),
//       SizedBox(
//         height: 200,
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 elevation: 10,
//                 child: Container(
//                     height: 100,
//                     width: 250,
//                     child: GoalsAchievedGraph(_userRepository)),
//               ),
//             ),
//             CrazyGoalCountdown(userRepository: _userRepository),
//           ],
//         ),
//       ),
//       _userRepository.diary.ultimateGoal.length!=0?Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: <Widget>[
//                 Text('Ultimate Goal'),
//                 Spacer(),
//               ],
//             ),
//           ),
//           UltimateGoalCard(
//             goal: _userRepository.diary.ultimateGoal[0],
//             onAchievedPressed: () {
//               BlocProvider.of<GoalsBloc>(context)
//                   .add(GoalAchieved(_userRepository.diary.ultimateGoal[0]));
// //                setState(() {});
//             },
//             onNotAchievedPressed: () {
//               BlocProvider.of<GoalsBloc>(context).add(
//                   GoalNotAchieved(_userRepository.diary.ultimateGoal[0]));
// //                setState(() {});
//             },
//             onShortPressed: () {
//               BlocProvider.of<GoalsBloc>(context).add(ChangeGoalsList(_userRepository.diary.ultimateGoal[0], 'Short Term'));
// //                setState(() {});
//             },
//             onMediumPressed: () {
//               BlocProvider.of<GoalsBloc>(context).add(ChangeGoalsList(_userRepository.diary.ultimateGoal[0], 'Medium Term'));
// //                setState(() {});
//             },
//             onLongPressed: () {
//               BlocProvider.of<GoalsBloc>(context).add(ChangeGoalsList(_userRepository.diary.ultimateGoal[0], 'Long Term'));
// //                setState(() {});
//             },
//             onDeletePressed: () {
//               BlocProvider.of<GoalsBloc>(context)
//                   .add(GoalDeleted(_userRepository.diary.ultimateGoal[0]));
// //                setState(() {});
//             },
//           ),
//         ],
//       ):Container(),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text('Secondary Goals'),
//       ),
//       TabBar(
//           indicatorWeight: 2,
//           indicatorSize: TabBarIndicatorSize.label,
//           labelColor: Color(0xff23232f),
//           labelStyle: TextStyle(fontSize: 10),
//           unselectedLabelColor: Colors.grey,
//           controller: tabController,
//           onTap: onTabTapped,
//           tabs: <Widget>[
//             Tab(
//               text: 'Short',
//             ),
//             Tab(
//               text: 'Medium',
//             ),
//             Tab(
//               text: 'Long',
//             ),
//             Tab(
//               text: 'Finished',
//             ),
//                 ]
//               ),]
//             )),
//             SliverFillRemaining(
//               child: TabBarView(
//                   children: _children,
//                   controller: tabController
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


