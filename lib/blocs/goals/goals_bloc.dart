import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goal_model.dart';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:meta/meta.dart';

part 'goals_event.dart';

part 'goals_state.dart';
/// BLoC called in goals page, to allow for the modification of goal types
class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final UserRepository userRepository;

  GoalsBloc({this.userRepository});
  var diaryBox = Hive.box('diaryBox');

  @override
  GoalsState get initialState {

    return InitialGoalsState(
          shortTermGoals: diaryBox.get('shortTermGoals'),
        mediumTermGoals: diaryBox.get('mediumTermGoals'),
        longTermGoals: diaryBox.get('longTermGoals'),
        finishedGoals: diaryBox.get('finishedGoals')
        );
  }

  @override
  Stream<GoalsState> mapEventToState(GoalsEvent event) async* {
    if(event is ChangeGoalsList){
      Goal _goal = event.goal;
      _goal.goalType = event.newList;
     _goal.changeGoalList();
     // processSendQueue(userRepository);
    }
    if(event is GoalAchieved){
      Goal goal = event.goal;
      goal.achieved = 'true';
      goal.goalType = 'Finished';
      goal.changeGoalList();
      processSendQueue(userRepository);
    }
    if(event is GoalNotAchieved){
      Goal goal = event.goal;
      goal.achieved = 'false';
      goal.goalType = 'Finished';
      goal.changeGoalList();
      // processSendQueue(userRepository);
    }
    if(event is GoalDeleted){
      event.goal.addToDeleteQueue();
      processDeleteQueue(userRepository);
    }
  }
}
