part of 'log_in_bloc.dart';

@immutable
abstract class LogInState extends Equatable {

  const LogInState();

  @override
  List<Object> get props => [];
}

class InitialLoginState extends LogInState {
}

class PasswordsDontMatch extends LogInState{

}

class SuccessfulLogin extends LogInState {}

class LoginFailure extends LogInState{
  final String message;

  LoginFailure(this.message);
  @override
  List<Object> get props => [message];
}

class IsSubmitting extends LogInState{}
