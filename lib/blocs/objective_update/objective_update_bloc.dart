import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goal_model.dart';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:meta/meta.dart';

part 'objective_update_event.dart';

part 'objective_update_state.dart';

class ObjectiveUpdateBloc
    extends Bloc<ObjectiveUpdateEvent, ObjectiveUpdateState> {
  final String objectiveType;
  final UserRepository userRepository;
  Objective _newObjective;
  Box diaryBox = Hive.box('diaryBox');

  ObjectiveUpdateBloc(
      {this.objectiveType, Objective newObjective, this.userRepository})
      : _newObjective = newObjective;

  @override
  ObjectiveUpdateState get initialState {
    _newObjective = Objective();
    _newObjective.objectiveType = objectiveType;
    _newObjective.average = 1;
    _newObjective.startDate = currentDay;
    _newObjective.endDate = currentDay;
    return InitialObjectiveUpdateState();
  }

  @override
  Stream<ObjectiveUpdateState> mapEventToState(
      ObjectiveUpdateEvent event) async* {
    if (event is UpdateAverage) {
      _newObjective.average = event.average;
      yield InitialObjectiveUpdateState();
    }
    if (event is UpdateLength) {
      print('event.length length: ');
      print(event.length);
      _newObjective.hoursOfWork = event.length;
    }
    if (event is UpdateDeadlineDate) {
      _newObjective.endDate = event.deadlineDate;
    }
    if (event is SubmitResponse) {
      _newObjective.id = 'x${DateTime.now().millisecondsSinceEpoch}';

      if (_newObjective.objectiveType == 'Performance' &&
          diaryBox.get('performanceObjective') != null) {
        Objective performanceObjective = diaryBox.get('performanceObjective');
        performanceObjective.isFinished = 'true';
        List finishedObjectives = diaryBox.get('finishedObjectives');
        finishedObjectives.add(performanceObjective);
        diaryBox.put('finishedObjectives', finishedObjectives);
      } else if (_newObjective.objectiveType == 'Hours Worked' &&
          diaryBox.get('hoursWorkedObjective') != null) {
        Objective hoursWorkedObjective = diaryBox.get('hoursWorkedObjective');
        hoursWorkedObjective.isFinished = 'true';
        List finishedObjectives = diaryBox.get('finishedObjectives');
        finishedObjectives.add(hoursWorkedObjective);
        diaryBox.put('finishedObjectives', finishedObjectives);
      } else if (_newObjective.objectiveType == 'Intensity' &&
          diaryBox.get('intensityObjective') != null) {
        Objective intensityObjective = diaryBox.get('intensityObjective');
        intensityObjective.isFinished = 'true';
        List finishedObjectives = diaryBox.get('finishedObjectives');
        finishedObjectives.add(intensityObjective);
        diaryBox.put('finishedObjectives', finishedObjectives);
      }
      _newObjective.addToSendQueue();
      yield Submitted();
      processDeleteQueue(userRepository);
      processSendQueue(userRepository);
    }
  }
}
