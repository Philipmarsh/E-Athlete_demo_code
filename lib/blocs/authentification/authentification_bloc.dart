import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../misc/user_repository.dart';

part 'authentification_event.dart';
part 'authentification_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Loading();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  /// called when app is started
  /// if user logged in then check for internet connection, if exists check JWT,
  /// if no internet then log in but don't do all api calls
  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();

    if (isSignedIn) {

      // TODO: add logic for sending anything left in the queue, needs to be done once internet connection is verified
      // try{
      // for (Session item in await DBHelper.getSessions()) {
      //   print(item.id);
      //   if (item.id[0] == "e" || item.id[0] == "x") {
      //     _userRepository.diaryItemsToSend.add(item);
      //   }
      //   if (item.id[0] == "d") {
      //     _userRepository.diaryItemsToDelete.add(item);
      //   }
      // }
      // }catch(e){
      //   print(e);
      // }

      if (await hasInternetConnection()) {
        try {
          await _userRepository.refreshIdToken().timeout(Duration(seconds: 6),
              onTimeout: () {
            return 'Connection Slow';
          });

          ///update user profile from server if internet connection exists
          // TODO: fix this method to work with hive
          // await DBHelper.getUser(_userRepository.user);
          try {

            await _userRepository.user
                .getUserInfo(await _userRepository.refreshIdToken());
            Box diaryBox = await Hive.openBox('diaryBox');
            Box userBox = await Hive.openBox('userBox');
            yield Authenticated();
          } catch (e) {
            _userRepository.signOut();
            Box diaryBox = await Hive.openBox('diaryBox');
            Box userBox = await Hive.openBox('userBox');
            diaryBox.deleteFromDisk();
            userBox.deleteFromDisk();
            yield Unauthenticated();
          }
        } catch (e) {
          _userRepository.signOut();
          Box diaryBox = await Hive.openBox('diaryBox');
          Box userBox = await Hive.openBox('userBox');
          diaryBox.deleteFromDisk();
          userBox.deleteFromDisk();
          yield Unauthenticated();
          print(e);
        }
      }

      ///login without checking user info and just loading sessions from internal
      ///DB
      else {
        await Hive.openBox('diaryBox');
        await Hive.openBox('userBox');
        yield Authenticated();
      }
    }

    ///if user is not signed in then yield unauthenticated
    else {
      yield Unauthenticated();
    }
  }

  /// When user signs in
  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated();
  }

  /// When user signs out
  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    await _userRepository.signOut();
    yield Unauthenticated();
  }
}
