part of 'goals_bloc.dart';

@immutable
abstract class GoalsState  extends Equatable{
  List shortTermGoals;
  List mediumTermGoals;
  List longTermGoals;
  List finishedGoals;
  @override
  List<Object> get props => [];
}

class InitialGoalsState extends GoalsState {
  final List shortTermGoals;
  final List mediumTermGoals;
  final List longTermGoals;
  final List finishedGoals;

  InitialGoalsState({this.shortTermGoals, this.mediumTermGoals, this.longTermGoals, this.finishedGoals});


  @override
  List<Object> get props => [shortTermGoals, mediumTermGoals, longTermGoals, finishedGoals];
}