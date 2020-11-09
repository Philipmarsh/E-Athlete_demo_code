import 'package:eathlete/misc/constants.dart';
import 'package:eathlete/misc/useful_functions.dart';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';

import 'dart:convert';
import '../misc/constants.dart';
import '../misc/exceptions.dart';
import '../misc/user_repository.dart';
part 'goal_model.g.dart';


@HiveType(typeId: 6)
class Goal extends DiaryModel{
  @HiveField(0)
  String content;
  @HiveField(1)
  String deadlineDate;
  @HiveField(2)
  String setOnDate;
  @HiveField(3)
  String goalType;
  @HiveField(4)
  String id;
  @HiveField(5)
  String achieved;

  Goal({this.content, this.deadlineDate, this.setOnDate, this.id, this.goalType, this.achieved='true'});



  void changeGoalList(){
    deleteFromPreviousGoalList();
    addToSendQueue();
  }

  void addToNewList(){

    Box diaryBox = Hive.box('diaryBox');
    if(goalType == 'Short Term'){
      List shortTermList = diaryBox.get('shortTermGoals');
      shortTermList.add(this);
      diaryBox.put('shortTermGoals', shortTermList);
    }
    else if(goalType == "Medium Term"){
      List mediumTermList = diaryBox.get('mediumTermGoals');
      mediumTermList.add(this);
      diaryBox.put('mediumTermGoals', mediumTermList);
    }
    else if(goalType == "Long Term"){
      List longTermList = diaryBox.get('longTermGoals');
      longTermList.add(this);
      diaryBox.put('longTermGoals', longTermList);
    }
    else if(goalType == "Finished"){
      List finishedList = diaryBox.get('finishedGoals');
      finishedList.add(this);
      diaryBox.put('finishedGoals', finishedList);
    }
    else if(goalType == "Ultimate"){
      List ultimateGoal = diaryBox.get('ultimateGoal');
      ultimateGoal.add(this);
      diaryBox.put('ultimateGoal', ultimateGoal);
    }
  }

  ///When a user presses submit, object is prepared for sending, and then added to
  ///items to send list. upload list will need to be called elsewhere in code
  ///
  ///ID starting with x signifies an object that has been saved on local storage
  ///but has not yet been added to online database
  ///
  ///ID starting with e signifies an object that has been edited from what is stored
  ///on the online DB
  ///
  /// ID starting with d signifies object has been deleted on local system but not on
  /// online DB

  // TODO: need to add into the right lists
  void addToSendQueue() {
    Box diaryBox = Hive.box('diaryBox');
    List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');

    //if new object, add id to the object and then add it to list to go
    if (id == null) {
      id = 'x' + DateTime.now().millisecondsSinceEpoch.toString();
      addToNewList();
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else if object starts with x send it straight to queue without changing id
    //also remove object from lists and replace with new info
    //also happens to objects that start with e as id does not need updating
    else if (id[0] == 'x' || id[0] == 'e') {
      addToNewList();
      diaryObjectsToSend
          .removeWhere((element) => element.id == id && element is Goal);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else add e to id and send to objectToSend (This should only be objects that
    //are up to date with the database
    else {
      id = 'e' + id;
      addToNewList();
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
  }



  Future<DiaryModel> upload(UserRepository _userRepository)async{
    Map body = {};
    if(content != null) body['content'] = this.content;
    if(deadlineDate != null) body['deadline'] = this.deadlineDate.toString().substring(0,10);
    if(setOnDate != null) body['set_on_date'] = this.setOnDate.toString().substring(0,10);
    if(id != null) body['id'] = this.id;
    if(goalType != null) body['goal_type'] = this.goalType;
    if(achieved != null) body['achieved'] = this.achieved;

    var response;
    String idToSend = this.id.substring(1);
    if (this.id[0] == "e") {
      response =
      await http.patch(kAPIAddress + '/api/goal/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      },
          body: body);
    } else {
      response = await http.post(kAPIAddress + '/api/goal/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }
    Map responseBody = jsonDecode(response.body);
    print(responseBody);
    if ((response.statusCode / 100).floor() != 2) {
      throw ServerErrorException;
    }

    Box diaryBox = Hive.box('diaryBox');
    if (response.statusCode == 201 || response.statusCode == 200) {
      deleteFromPreviousGoalList();
      List diaryItemsToSend = diaryBox.get('diaryObjectsToSend');
      diaryItemsToSend.remove(this);
      diaryBox.put('diaryObjectsToSend', diaryItemsToSend);
      id = responseBody['id'].toString();
      setOnDate = responseBody['set_on_date'];
      deadlineDate = responseBody['deadline_date'].toString();
      addToNewList();
      print(diaryBox.get('diaryObjectsToSend'));
    }


    return this;
  }

  void deleteFromPreviousGoalList(){
    Box diaryBox = Hive.box('diaryBox');
    bool isLong = false;
    bool isMedium = false;
    bool isShort = false;
    bool isUltimate = false;
    bool isFinished = false;
    for(Goal goal in diaryBox.get('shortTermGoals')){
      if(id == goal.id)isShort=true;
    }
    for(Goal goal in diaryBox.get('mediumTermGoals')){
      if(id == goal.id)isMedium=true;
    }
    for(Goal goal in diaryBox.get('longTermGoals')){
      if(id == goal.id)isLong=true;
    }
    for(Goal goal in diaryBox.get('ultimateGoal')){
      if(id == goal.id)isUltimate=true;
    }
    for(Goal goal in diaryBox.get('finishedGoals')){
      if(id == goal.id) isFinished=true;
    }
    if(isShort == true) {
      List shortTermGoals = diaryBox.get('shortTermGoals');
      shortTermGoals.removeWhere((element) => element.id == id);
      diaryBox.put('shortTermGoals', shortTermGoals);
    }
    if(isMedium == true) {
      List mediumTermGoals = diaryBox.get('mediumTermGoals');
      mediumTermGoals.removeWhere((element) => element.id == id);
      diaryBox.put('mediumTermGoals', mediumTermGoals);
    }
    if(isLong == true) {
      List longTermGoals = diaryBox.get('longTermGoals');
      longTermGoals.removeWhere((element) => element.id == id);
      diaryBox.put('longTermGoals', longTermGoals);
    }
    if(isUltimate == true) {
      List ultimateGoal = diaryBox.get('ultimateGoal');
      ultimateGoal.removeWhere((element) => element.id == id);
      diaryBox.put('ultimateGoal', ultimateGoal);
    }
    if(isFinished == true) {
      List finishedGoals = diaryBox.get('finishedGoals');
      finishedGoals.removeWhere((element) => element.id == id);
      diaryBox.put('finishedGoals', finishedGoals);
    }

  }

  ///when user presses delete on a session, this function removes it from the
  ///the sessionList and adds it to the delete queue. This will then be removed
  ///from the server next time delete queue is emptied
  void addToDeleteQueue() {
    Box diaryBox = Hive.box('diaryBox');
    deleteFromPreviousGoalList();
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.add(this);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  ///called from within the delete queue, if the item has not been synced with
  ///the database, will delete from list(x prefix), else will send delete request to database
  ///for current object (no prefix or e prefix)
  Future<void> deleteObject(UserRepository _userRepository) async {
    Box diaryBox = Hive.box('diaryBox');

    if (id[0] != 'x') {
      String idToSend = id[0] == 'e' ? id.substring(1) : id;
      await http.delete(kAPIAddress + '/api/goal/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      });
    }
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.remove(this);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  /// Converts object to a string
  String toString() {
    return 'id: $id, achieved: $achieved, setOnDate: $setOnDate, deadlineDate: $deadlineDate'
        ' content: $content, goalType: $goalType';
  }






}

Future<List<Goal>> getGoals(String jwt, String type) async{
  var response = await http.get(kAPIAddress + '/api/goal/',
      headers: {'Authorization': 'JWT ' + jwt});
  assert(response.statusCode == 200);
  List body = jsonDecode(response.body);
  List<Goal> goals = [];
  for(var goal in body){
    Goal _newGoal = Goal()
      ..achieved = goal['achieved']
      ..setOnDate = goal['set_on_date']
      ..deadlineDate = goal['deadline']
      ..id = goal['id'].toString()
      ..content = goal['content']
      ..goalType = goal['goal_type'];
    if(_newGoal.goalType[0] == type[0]) {
      goals.add(_newGoal);
    }
  }
  return goals;
}

@HiveType(typeId: 7)
class Objective extends DiaryModel{

  @HiveField(0)
  DateTime startDate;
  @HiveField(1)
  DateTime endDate;
  @HiveField(2)
  String isFinished;
  @HiveField(3)
  String objectiveType;
  @HiveField(4)
  int average = 0;
  @HiveField(5)
  int hoursOfWork = 0;
  @HiveField(6)
  String id;


  Objective({ this.startDate, this.endDate, this.isFinished='false', this.objectiveType, this.hoursOfWork =1, this.average=5, this.id});



  ///When a user presses submit, object is prepared for sending, and then added to
  ///items to send list. upload list will need to be called elsewhere in code
  ///
  ///ID starting with x signifies an object that has been saved on local storage
  ///but has not yet been added to online database
  ///
  ///ID starting with e signifies an object that has been edited from what is stored
  ///on the online DB
  ///
  /// ID starting with d signifies object has been deleted on local system but not on
  /// online DB
  void addToSendQueue() {
    Box diaryBox = Hive.box('diaryBox');
    List<Objective> objectiveList = diaryBox.get('objectiveList');
    List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');

    //if new object, add id to the object and then add it to list to go
    if (id == null) {
      id = 'x' + DateTime.now().millisecondsSinceEpoch.toString();
      objectiveList.add(this);
      diaryBox.put('objectiveList', objectiveList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else if object starts with x send it straight to queue without changing id
    //also remove object from lists and replace with new info
    //also happens to objects that start with e as id does not need updating
    else if (id[0] == 'x' || id[0] == 'e') {
      objectiveList
          .removeWhere((element) => element.id == id && element is Objective);
      objectiveList.add(this);
      diaryBox.put('objectiveList', objectiveList);
      diaryObjectsToSend
          .removeWhere((element) => element.id == id && element is Objective);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else add e to id and send to objectToSend (This should only be objects that
    //are up to date with the database
    else {
      objectiveList
          .removeWhere((element) => element.id == id && element is Objective);
      id = 'e' + id;
      objectiveList.add(this);
      diaryBox.put('objectiveList', objectiveList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
  }

  Future<DiaryModel> upload(UserRepository _userRepository) async {
    Map body = {};
    if (this.startDate != null)
      body['start_date'] = this.startDate.toString();
    if (this.isFinished != null) body['is_finished'] = this.isFinished;
    if (this.endDate != null) body['end_date'] = this.endDate.toString();
    if (this.objectiveType != null)
      body['objective_type'] = this.objectiveType.toString();
    if (this.hoursOfWork != null) body['hours_of_work'] = this.hoursOfWork.toString();
    if (this.average != null) body['average'] = this.average.toString();
    if (this.startDate != null) body['start_date'] = this.startDate.toString().substring(0, 10);
    if (this.endDate != null) body['end_date'] = this.endDate.toString().substring(0, 10);

    var response;
    String tempid = this.id.substring(1);
    if (this.id[0] == "e") {
      response =
      await http.patch(kAPIAddress + '/api/objective/$tempid/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      },
          body: body);
    } else {
      response = await http.post(kAPIAddress + '/api/objective/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }
    Map responseBody = jsonDecode(response.body);
    print(responseBody);
    if ((response.statusCode / 100).floor() != 2) {
      throw ServerErrorException;
    }

    Objective _newObjective = Objective(
      startDate: DateTime.parse(responseBody['start_date']),
      endDate: DateTime.parse(responseBody['end_date']),
      isFinished: responseBody['is_finished'],
      objectiveType: responseBody['objective_type'],
      hoursOfWork: responseBody['hours_of_work'],
      average: responseBody['average'],
      id: responseBody['id'].toString()
    );


    Box diaryBox = Hive.box('diaryBox');
    if (response.statusCode == 201 || response.statusCode == 200) {
      List objectiveList = diaryBox.get('objectiveList');
      objectiveList.remove(this);
      List diaryItemsToSend = diaryBox.get('diaryObjectsToSend');
      diaryItemsToSend.remove(this);
      diaryBox.put('diaryObjectsToSend', diaryItemsToSend);
      objectiveList.add(_newObjective);
      diaryBox.put('objectiveList', objectiveList);
      print(diaryBox.get('diaryObjectsToSend'));
    }

    return _newObjective;
  }


  ///when user presses delete on a session, this function removes it from the
  ///the sessionList and adds it to the delete queue. This will then be removed
  ///from the server next time delete queue is emptied
  void addToDeleteQueue() {
    Box diaryBox = Hive.box('diaryBox');
    List<Objective> objectiveList = diaryBox.get('objectiveList');
    objectiveList.remove(this);
    diaryBox.put('objectiveList', objectiveList);
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.add(this);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  ///called from within the delete queue, if the item has not been synced with
  ///the database, will delete from list(x prefix), else will send delete request to database
  ///for current object (no prefix or e prefix)
  Future<void> deleteObject(UserRepository _userRepository) async {
    Box diaryBox = Hive.box('diaryBox');

    if (id[0] != 'x') {
      String idToSend = id[0] == 'e' ? id.substring(1) : id;
      await http.delete(kAPIAddress + '/api/objective/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      });
    }
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.remove(this);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  /// Converts object to a string
  String toString() {
    return 'id: $id, isFinished: $isFinished, startDate: $startDate, endDate: $endDate'
        ' objectiveType: $objectiveType';
  }





}

Future<Objective> getObjective(String jwt, String type) async {
  var response = await http.get(kAPIAddress + '/api/objective/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<Objective> objectives = [];
  for (var day in body) {
    Objective objective = Objective()
      ..startDate = DateTime.parse(day['start_date'])
      ..endDate = DateTime.parse(day['end_date'])
      ..isFinished = day['is_finished']
      ..objectiveType = day['objective_type']
      ..average = day['average']
      ..hoursOfWork = day['hours_of_work']
      ..id = day['id'].toString();
    if(objective.objectiveType == type){
        objectives.add(objective);
    }
  }
  if(objectives.length>0) {
    return objectives.last;
  } else{
    return null;
  }
}


