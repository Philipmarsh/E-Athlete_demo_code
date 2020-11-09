import 'dart:convert';
import 'package:hive/hive.dart';
import '../misc/constants.dart';
import 'package:http/http.dart' as http;
import '../misc/exceptions.dart';
import '../misc/user_repository.dart';
part 'diary_model.g.dart';


// TODO: write better comments in here


abstract class DiaryModel extends HiveObject {
  Future<DiaryModel> upload(UserRepository userRepository);

  Future<void> deleteObject(UserRepository userRepository);
}

@HiveType(typeId: 2)
class Session extends DiaryModel {
  @HiveField(0)
  String date;
  @HiveField(1)
  int lengthOfSession;
  @HiveField(2)
  String title;
  @HiveField(3)
  int intensity;
  @HiveField(4)
  int performance;
  @HiveField(5)
  String feeling;
  @HiveField(6)
  String target;
  @HiveField(7)
  String reflections;
  @HiveField(8)
  String id;

  Session({
    this.date,
    this.lengthOfSession,
    this.title,
    this.intensity,
    this.performance,
    this.feeling,
    this.target,
    this.reflections,
    this.id,
  });

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
    if (id == null) {
      id = 'x' + DateTime.now().millisecondsSinceEpoch.toString();
      List sessionList = diaryBox.get('sessionList');
      sessionList.add(this);
      diaryBox.put('sessionList', sessionList);
      List objectsToSend = diaryBox.get('diaryObjectsToSend');
      objectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', objectsToSend);
    }
    //else if object starts with x send it straight to queue without changing id
    //also remove object from lists and replace with new info
    //also happens to objects that start with e as id does not need updating
    else if (id[0] == 'x' || id[0] == 'e') {
      List<Session> sessionList = diaryBox.get('sessionList');
      sessionList.removeWhere((element) => element.id == id);
      sessionList.add(this);
      diaryBox.put('sessionList', sessionList);
      List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');
      diaryObjectsToSend.removeWhere((element) => element.id == id);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else add e to id and send to objectToSend (This should only be objects that
    //are up to date with the database
    else {
      List<Session> sessionList = diaryBox.get('sessionList');
      sessionList.removeWhere((element) => element.id == id);
      List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');
      diaryObjectsToSend.removeWhere((element) => element.id == id);
      id = 'e' + id;
      sessionList.add(this);
      diaryBox.put('sessionList', sessionList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
  }

  /// Uploads current instance of session to server.
  /// If there is no internet connection then save it to a list ready to be
  /// uploaded when internet connection comes back
  Future<Session> upload(UserRepository _userRepository) async {
    // add information to body
    Map body = {};
    if (this.lengthOfSession != null)
      body['time'] = this.lengthOfSession.toString();
    if (this.title != null) body['title'] = this.title;
    if (this.intensity != null) body['intensity'] = this.intensity.toString();
    if (this.performance != null)
      body['performance'] = this.performance.toString();
    if (this.feeling != null) body['feeling'] = this.feeling;
    if (this.target != null) body['target'] = this.target;
    if (this.reflections != null) body['reflections'] = this.reflections;
    if (this.date != null) body['date'] = this.date.substring(0, 10);

    //if its being edited, sent in patch request, else in post request
    var response;
    String idToSend = this.id.substring(1);
    if (this.id[0] == "e") {
      response = await http.patch(kAPIAddress + '/api/session/$idToSend/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    } else {
      response = await http.post(kAPIAddress + '/api/session/',
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
    Session _newSession = Session(
        title: responseBody['title'],
        date: responseBody['date'],
        lengthOfSession: responseBody['time'],
        intensity: responseBody['intensity'],
        performance: responseBody['performance'],
        feeling: responseBody['feeling'],
        target: responseBody['target'],
        reflections: responseBody['reflections'],
        id: responseBody['id'].toString());

    Box diaryBox = Hive.box('diaryBox');
    if (response.statusCode == 201 || response.statusCode == 200) {
      List sessionList = diaryBox.get('sessionList');
      sessionList.remove(this);
      List diaryItemsToSend = diaryBox.get('diaryObjectsToSend');
      diaryItemsToSend.remove(this);
      diaryBox.put('diaryObjectsToSend', diaryItemsToSend);
      sessionList.add(_newSession);
      diaryBox.put('sessionList', sessionList);
      print(diaryBox.get('diaryObjectsToSend'));
    }

    return _newSession;
  }

  ///when user presses delete on a session, this function removes it from the
  ///the sessionList and adds it to the delete queue. This will then be removed
  ///from the server next time delete queue is emptied
  void addToDeleteQueue() {
    Box diaryBox = Hive.box('diaryBox');
    print('got here');
    List sessionList = diaryBox.get('sessionList');
    print('got here now');
    sessionList.removeWhere((element) => element.id == id);
    diaryBox.put('sessionList', sessionList);
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
      var response = await http.delete(kAPIAddress + '/api/session/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      });
      print(response.statusCode);
    }

    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.removeWhere((element) => element.id == id);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  String toString() {
    String string =
        'id: $id, title: $title, date: $date, lengthOfSession: $lengthOfSession'
        ' intensity: $intensity, performance: $performance, feeling: $feeling,'
        ' target: $target, reflections: $reflections';

    return string;
  }
}

Future<List<Session>> getSessionList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/session/',
      headers: {'Authorization': 'JWT ' + jwt});
  assert(response.statusCode == 200);
  List body = jsonDecode(response.body);
  List<Session> sessions = [];
  for (var session in body) {
    Session newSession = Session()
      ..title = session['title']
      ..date = session['date']
      ..lengthOfSession = session['time']
      ..intensity = session['intensity']
      ..performance = session['performance']
      ..feeling = session['feeling']
      ..target = session['target']
      ..reflections = session['reflections']
      ..id = session['id'].toString();

    sessions.add(newSession);
  }
  return sessions;
}

@HiveType(typeId: 3)
class GeneralDay extends DiaryModel {
  @HiveField(0)
  String date;
  @HiveField(1)
  int rested;
  @HiveField(2)
  int nutrition;
  @HiveField(3)
  int concentration;
  @HiveField(4)
  String reflections;
  @HiveField(5)
  String id;

  GeneralDay(
      {this.date,
      this.rested,
      this.nutrition,
      this.concentration,
      this.reflections,
      this.id});

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
    //if new object, add id to the object and then add it to list to go
    if (id == null) {
      id = 'x' + DateTime.now().millisecondsSinceEpoch.toString();
      List generalDayList = diaryBox.get('generalDayList');
      generalDayList.add(this);
      diaryBox.put('generalDayList', generalDayList);
      List objectsToSend = diaryBox.get('diaryObjectsToSend');
      objectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', objectsToSend);
    }
    //else if object starts with x send it straight to queue without changing id
    //also remove object from lists and replace with new info
    //also happens to objects that start with e as id does not need updating
    else if (id[0] == 'x' || id[0] == 'e') {
      List generalDayList = diaryBox.get('generalDayList');
      generalDayList.removeWhere((element) => element.id == id);
      generalDayList.add(this);
      diaryBox.put('generalDayList', generalDayList);
      List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');
      diaryObjectsToSend.removeWhere((element) => element.id == id);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else add e to id and send to objectToSend (This should only be objects that
    //are up to date with the database
    else {
      List generalDayList = diaryBox.get('generalDayList');
      generalDayList.removeWhere((element) => element.id == id);
      List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');
      diaryObjectsToSend.removeWhere((element) => element.id == id);
      id = 'e' + id;
      generalDayList.add(this);
      diaryBox.put('generalDayList', generalDayList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
  }

  /// Updates the server with a new general day and then adds this to the onboard
  /// sql table*
  Future<GeneralDay> upload(UserRepository _userRepository) async {
    Map body = {};
    if (this.date != null) body['date'] = this.date;
    if (this.rested != null) body['rested'] = this.rested.toString();
    if (this.nutrition != null) body['nutrition'] = this.nutrition.toString();
    if (this.concentration != null)
      body['concentration'] = this.concentration.toString();
    if (this.reflections != null) body['reflections'] = this.reflections;
    if (this.date != null) body['date'] = this.date.substring(0, 10);

    var response;
    String idToSend = this.id.substring(1);
    if (this.id[0] == "e") {
      response = await http.patch(kAPIAddress + '/api/general-day/$idToSend/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    } else {
      response = await http.post(kAPIAddress + '/api/general-day/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }

    Map responseBody = jsonDecode(response.body);
    print(responseBody.toString());
    //checks that the upload has been successful
    if ((response.statusCode / 100).floor() != 2) {
      print(response.statusCode / 100);
      throw ServerErrorException;
    }
    //uploads the new general day to the DB
    GeneralDay _newGeneralDay = GeneralDay(
        date: responseBody['date'],
        rested: responseBody['rested'],
        nutrition: responseBody['nutrition'],
        concentration: responseBody['concentration'],
        reflections: responseBody['reflections'],
        id: responseBody['id'].toString());

    Box diaryBox = Hive.box('diaryBox');
    if (response.statusCode == 201 || response.statusCode == 200) {
      List generalDayList = diaryBox.get('generalDayList');
      generalDayList.remove(this);
      List diaryItemsToSend = diaryBox.get('diaryObjectsToSend');
      diaryItemsToSend.remove(this);
      diaryBox.put('diaryObjectsToSend', diaryItemsToSend);
      generalDayList.add(_newGeneralDay);
      diaryBox.put('generalDayList', generalDayList);
    }

    return _newGeneralDay;
  }

  ///when user presses delete on a session, this function removes it from the
  ///the sessionList and adds it to the delete queue. This will then be removed
  ///from the server next time delete queue is emptied
  void addToDeleteQueue() {
    Box diaryBox = Hive.box('diaryBox');
    List generalDayList = diaryBox.get('generalDayList');
    generalDayList.removeWhere((element) => element.id == id);
    diaryBox.put('generalDayList', generalDayList);
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
      await http.delete(kAPIAddress + '/api/general-day/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      });
    }
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete
        .removeWhere((element) => element.id == id && element is GeneralDay);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  String toString() {
    return 'id: $id, date: $date, rested: $rested, nutrition: $nutrition'
        ' concentration: $concentration, reflections: $reflections';
  }
}

Future<List<GeneralDay>> getGeneralDayList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/general-day/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<GeneralDay> generalDays = [];
  for (var day in body) {
    GeneralDay newDay = GeneralDay()
      ..date = day['date']
      ..rested = day['rested']
      ..nutrition = day['nutrition']
      ..concentration = day['concentration']
      ..reflections = day['reflections']
      ..id = day['id'].toString();
    generalDays.add(newDay);
  }

  return generalDays;
}

@HiveType(typeId: 4)
class Competition extends DiaryModel {
  @HiveField(0)
  String date;
  @HiveField(1)
  String name;
  @HiveField(2)
  String address;
  @HiveField(3)
  String startTime;
  @HiveField(4)
  String id;

  Competition({this.date, this.name, this.address, this.startTime, this.id});

  // /api/competition/$tempid/

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
    List competitionList = diaryBox.get('competitionList');
    List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');

    //if new object, add id to the object and then add it to list to go
    if (id == null) {
      id = 'x' + DateTime.now().millisecondsSinceEpoch.toString();
      competitionList.add(this);
      diaryBox.put('competitionList', competitionList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else if object starts with x send it straight to queue without changing id
    //also remove object from lists and replace with new info
    //also happens to objects that start with e as id does not need updating
    else if (id[0] == 'x' || id[0] == 'e') {
      competitionList
          .removeWhere((element) => element.id == id && element is Competition);
      competitionList.add(this);
      diaryBox.put('competitionList', competitionList);
      diaryObjectsToSend
          .removeWhere((element) => element.id == id && element is Competition);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else add e to id and send to objectToSend (This should only be objects that
    //are up to date with the database
    else {
      competitionList
          .removeWhere((element) => element.id == id && element is Competition);
      id = 'e' + id;
      competitionList.add(this);
      diaryBox.put('competitionList', competitionList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
  }

  Future<Competition> upload(UserRepository _userRepository) async {
    Map body = {};
    if (this.date != null) body['date'] = this.date;
    if (this.name != null) body['name'] = this.name;
    if (this.address != null) body['address'] = this.address;
    if (this.startTime != null) body['start_time'] = this.startTime;
    if (this.date != null) body['date'] = this.date.substring(0, 10);

    var response;

    String tempid = this.id.substring(1);
    if (this.id[0] == "e") {
      response = await http.patch(kAPIAddress + '/api/competition/$tempid/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    } else {
      response = await http.post(kAPIAddress + '/api/competition/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }

    Map responseBody = jsonDecode(response.body);
    if ((response.statusCode / 100).floor() != 2) {
      throw ServerErrorException;
    }
    Competition _newCompetition = Competition()
      ..name = responseBody['name']
      ..date = responseBody['date']
      ..address = responseBody['address']
      ..startTime = responseBody['start_time']
      ..id = responseBody['id'].toString();

    Box diaryBox = Hive.box('diaryBox');
    if (response.statusCode == 201 || response.statusCode == 200) {
      List competitionList = diaryBox.get('competitionList');
      competitionList.remove(this);
      List diaryItemsToSend = diaryBox.get('diaryObjectsToSend');
      diaryItemsToSend.remove(this);
      diaryBox.put('diaryObjectsToSend', diaryItemsToSend);
      competitionList.add(_newCompetition);
      diaryBox.put('competitionList', competitionList);
      print(diaryBox.get('diaryObjectsToSend'));
    }

    return _newCompetition;
  }

  ///when user presses delete on a session, this function removes it from the
  ///the sessionList and adds it to the delete queue. This will then be removed
  ///from the server next time delete queue is emptied
  void addToDeleteQueue() {
    Box diaryBox = Hive.box('diaryBox');
    List competitionList = diaryBox.get('competitionList');
    competitionList.remove(this);
    diaryBox.put('competitionList', competitionList);
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
      await http.delete(kAPIAddress + '/api/competition/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      });
    }
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.remove(this);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  /// Converts object to a string
  String toString() {
    return 'id: $id, date: $date, name: $name, address: $address'
        ' startTime: $startTime';
  }
}

Future<List<Competition>> getCompetitionList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/competition/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<Competition> competitions = [];
  for (var competition in body) {
    Competition newComp = Competition()
      ..date = competition['date']
      ..name = competition['name']
      ..address = competition['address']
      ..startTime = competition['start_time']
      ..id = competition['id'].toString();

    competitions.add(newComp);
  }
  return competitions;
}

@HiveType(typeId: 5)
class Result extends DiaryModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String date;
  @HiveField(2)
  String name;
  @HiveField(3)
  int position;
  @HiveField(4)
  String reflections;

  Result({this.id, this.date, this.name, this.position, this.reflections});

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
    List resultList = diaryBox.get('resultList');
    List diaryObjectsToSend = diaryBox.get('diaryObjectsToSend');

    //if new object, add id to the object and then add it to list to go
    if (id == null) {
      id = 'x' + DateTime.now().millisecondsSinceEpoch.toString();
      resultList.add(this);
      diaryBox.put('resultList', resultList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else if object starts with x send it straight to queue without changing id
    //also remove object from lists and replace with new info
    //also happens to objects that start with e as id does not need updating
    else if (id[0] == 'x' || id[0] == 'e') {
      resultList
          .removeWhere((element) => element.id == id && element is Result);
      resultList.add(this);
      diaryBox.put('resultList', resultList);
      diaryObjectsToSend
          .removeWhere((element) => element.id == id && element is Result);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
    //else add e to id and send to objectToSend (This should only be objects that
    //are up to date with the database
    else {
      resultList
          .removeWhere((element) => element.id == id && element is Result);
      id = 'e' + id;
      resultList.add(this);
      diaryBox.put('resultList', resultList);
      diaryObjectsToSend.add(this);
      diaryBox.put('diaryObjectsToSend', diaryObjectsToSend);
    }
  }

  Future<Result> upload(UserRepository _userRepository) async {
    Map body = {};
    if (this.date != null) body['date'] = this.date;
    if (this.name != null) body['name'] = this.name;
    if (this.position != null) body['position'] = this.position.toString();
    if (this.reflections != null) body['reflections'] = this.reflections;
    var response;
    String idToSend = this.id.substring(1);
    if (this.id[0] == "e") {
      response = await http.patch(kAPIAddress + '/api/result/$idToSend/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    } else {
      response = await http.post(kAPIAddress + '/api/result/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }
    Map responseBody = jsonDecode(response.body);
    if ((response.statusCode / 100).floor() != 2) {
      throw ServerErrorException;
    }
    Result _newResult = Result(
        name: responseBody['name'],
        date: responseBody['date'],
        position: responseBody['position'],
        reflections: responseBody['reflections'],
        id: responseBody['id'].toString());

    Box diaryBox = Hive.box('diaryBox');
    if (response.statusCode == 201 || response.statusCode == 200) {
      List resultList = diaryBox.get('resultList');
      resultList.remove(this);
      List diaryItemsToSend = diaryBox.get('diaryObjectsToSend');
      diaryItemsToSend.remove(this);
      diaryBox.put('diaryObjectsToSend', diaryItemsToSend);
      resultList.add(_newResult);
      diaryBox.put('resultList', resultList);
      print(diaryBox.get('diaryObjectsToSend'));
    }

    return _newResult;
  }

  ///when user presses delete on a session, this function removes it from the
  ///the sessionList and adds it to the delete queue. This will then be removed
  ///from the server next time delete queue is emptied
  void addToDeleteQueue() {
    Box diaryBox = Hive.box('diaryBox');
    List resultList = diaryBox.get('resultList');
    resultList.remove(this);
    diaryBox.put('resultList', resultList);
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
      await http.delete(kAPIAddress + '/api/result/$idToSend/', headers: {
        'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
      });
    }
    List diaryObjectsToDelete = diaryBox.get('diaryObjectsToDelete');
    diaryObjectsToDelete.remove(this);
    diaryBox.put('diaryObjectsToDelete', diaryObjectsToDelete);
  }

  /// Converts object to a string
  String toString() {
    return 'id: $id, date: $date, name: $name, position: $position'
        ' reflections: $reflections';
  }
}

Future<List<Result>> getResultList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/result/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<Result> results = [];
  for (var result in body) {
    Result newResult = Result()
      ..date = result['date']
      ..name = result['name']
      ..position = result['position']
      ..reflections = result['reflections']
      ..id = result['id'].toString();

    results.add(newResult);
  }
  print(results);
  return results;
}
