import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:meta/meta.dart';

import '../../misc/user_repository.dart';



part 'log_in_event.dart';

part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  final UserRepository _userRepository;

  LogInBloc(UserRepository userRepository): assert(userRepository != null),
  _userRepository = userRepository;
  Map<String, String> errorMessages = {
    'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)': 'Account already exists',
  'PlatformException(ERROR_WEAK_PASSWORD, The password must be 6 characters long or more., null)': 'Password must be at least 6 characters long',
    'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)': 'Email Address not valid',
    'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)': 'Incorrect email or password',
    'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)':'Incorrect email or password'

  };



  @override
  LogInState get initialState => InitialLoginState();

  String password2;
  String email;
  String password;

  @override
  Stream<LogInState> mapEventToState(LogInEvent event) async* {
    if(event is Password2Changed){
      password2 = event.password2;
      if(password2 == password){
        yield PasswordsDontMatch();
      }
      else {
        yield InitialLoginState();
      }
    }
    else if(event is EmailChanged){
      email = event.email;
      yield InitialLoginState();
    }
    else if(event is PasswordChanged){
      password = event.password;
      yield InitialLoginState();
    }
    else if(event is Submitted){
      yield IsSubmitting();
      try {
        await _userRepository.signInWithCredentials(email, password, event.isDelete);
        yield SuccessfulLogin();
      } catch (e){
        print(e.toString());
        String errorMessage = errorMessages[e.toString()]??'Login Failure';
        yield LoginFailure(errorMessage);
      }

    }
    else if(event is SignUp){
      if(password == password2) {
        print(email);
        yield IsSubmitting();
        try {
          await _userRepository.signUp(email: email.trim(), password: password);
          print('user created');
          await _userRepository.signInWithCredentials(email, password, false);
          yield SuccessfulLogin();
        } catch (e) {
          String errorMessage = errorMessages[e.toString()]??'Login Failure';
          yield LoginFailure(errorMessage);
        }
      }else{yield PasswordsDontMatch();}
    }
    else if(event is FacebookLoginAttempt){
      yield IsSubmitting();
      try{
        await _userRepository.signInWithFacebook(event.isDelete);
        yield SuccessfulLogin();
      } catch (e) {
        String errorMessage = errorMessages[e.toString()]??'Login Failure';
        yield LoginFailure(errorMessage);
      }
    }
    else if (event is GoogleLogin){
      yield IsSubmitting();
      try {
        await _userRepository.signInWithGoogle(event.isDelete);
        yield SuccessfulLogin();
      } catch (e) {
        String errorMessage = errorMessages[e.toString()]??'Login Failure';
        yield LoginFailure(errorMessage);
      }
    }
    else if (event is AppleLogin){
      yield IsSubmitting();
      try {
        await _userRepository.signInWithApple(event.isDelete);
        yield SuccessfulLogin();
      } catch (e) {
        String errorMessage = errorMessages[e.toString()]??'Login Failure';
        yield LoginFailure(errorMessage);
      }
    }
  }
}
