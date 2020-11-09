import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goal_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';



part 'goal_update_event.dart';

part 'goal_update_state.dart';
///BLoC called when wanting to create a goal
///Also will be called to update a goal in the future
class GoalUpdateBloc extends Bloc<GoalUpdateEvent, GoalUpdateState> {
  final UserRepository userRepository;
  final String goalType;
  final Goal _goal;
  Box diaryBox = Hive.box('diaryBox');

  GoalUpdateBloc(this.userRepository,
      {this.goalType = 'not working', Goal goal})
      : _goal = goal ?? Goal(setOnDate: DateTime.now().toIso8601String(), deadlineDate: DateTime.now().toString(), id: 'x${DateTime.now().millisecondsSinceEpoch}', goalType: goalType);

  @override
  GoalUpdateState get initialState => InitialGoalUpdateState(goalType);

  @override
  Stream<GoalUpdateState> mapEventToState(GoalUpdateEvent event) async* {
    if(event is UpdateGoalDate){
      _goal.deadlineDate = event.deadline.toIso8601String();
      yield(InitialGoalUpdateState(goalType));
    }
    if(event is UpdateGoalContent){
      _goal.content = event.content;
      yield(InitialGoalUpdateState(goalType));
    }
    if(event is Submit){

      _goal.addToSendQueue();
      yield(InformationSubmitted());
      // processSendQueue(userRepository);
    }
    if(event is SubmitFromHomePage){
      _goal.deadlineDate = DateTime.now().toIso8601String();
      _goal.setOnDate = DateTime.now().toIso8601String();
      _goal.goalType = 'Short Term';
      _goal.id = 'x${DateTime.now().millisecondsSinceEpoch}';
      _goal.addToSendQueue();
      yield InformationSubmitted();
      processSendQueue(userRepository);
    }
  }
}
