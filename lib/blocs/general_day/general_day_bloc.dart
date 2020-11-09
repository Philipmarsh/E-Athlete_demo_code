import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/class_definitions.dart';
import 'package:eathlete/models/diary_model.dart';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';


import 'package:meta/meta.dart';

import '../../misc/user_repository.dart';

part 'general_day_event.dart';

part 'general_day_state.dart';

class GeneralDayBloc extends Bloc<GeneralDayEvent, GeneralDayState> {

  GeneralDay _generalDay;
  UserRepository _userRepository;
  Last7DaysChooser _last7daysChooser = Last7DaysChooser();

  GeneralDayBloc(this._userRepository,{GeneralDay generalDay}):_generalDay = generalDay ??
      GeneralDay(date: DateTime.now().toIso8601String(), );

  @override
  GeneralDayState get initialState => InitialGeneralDayState(_generalDay, _last7daysChooser);

  @override
  Stream<GeneralDayState> mapEventToState(GeneralDayEvent event) async* {
    if(event is UpdateRested){
      _generalDay.rested = event.rested;
      yield InitialGeneralDayState(_generalDay, _last7daysChooser);
    }
    else if(event is UpdateNutrition){
      _generalDay.nutrition = event.nutrition;
      yield InitialGeneralDayState(_generalDay, _last7daysChooser);
    }
    else if(event is UpdateConcentration){
      _generalDay.concentration = event.concentration;
      yield InitialGeneralDayState(_generalDay, _last7daysChooser);
    }
    else if(event is UpdateReflections){
      _generalDay.reflections =event.reflections;
      yield InitialGeneralDayState(_generalDay, _last7daysChooser);
    }
    else if(event is Submit){
      yield IsSubmitting(_generalDay, _last7daysChooser);
      if(_generalDay.concentration == null)_generalDay.concentration = 5;
      if(_generalDay.nutrition == null)_generalDay.nutrition = 5;
      if(_generalDay.rested == null)_generalDay.rested = 3;
      try{
         _generalDay.addToSendQueue();
        yield SubmissionSuccessful(_generalDay, _last7daysChooser);
        //need to send diaryItems if possible
        processSendQueue(_userRepository);
      }catch(e){
        print(e);
        yield SubmissionFailed(_generalDay, _last7daysChooser);
      }
    }
    else if(event is ChangeDateForwards){
      _last7daysChooser.changeDateForward();
      _generalDay.date = _last7daysChooser.previous7Days[_last7daysChooser.dayPointer].toIso8601String();
    }
    else if(event is ChangeDateBackwards){
      _last7daysChooser.changeDateBackward();
      _generalDay.date = _last7daysChooser.previous7Days[_last7daysChooser.dayPointer].toIso8601String();
    }
  }
}
