import 'package:equatable/equatable.dart';

/// Base class for authentication events
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// Event fired when email is changed
class AuthenticationEmailChanged extends AuthenticationEvent {
  const AuthenticationEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

/// Event fired when password is changed
class AuthenticationPasswordChanged extends AuthenticationEvent {
  const AuthenticationPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

/// Event fired when login is submitted
class AuthenticationLoginSubmitted extends AuthenticationEvent {
  const AuthenticationLoginSubmitted();
}

/// Event fired when sign up is submitted
class AuthenticationSignUpSubmitted extends AuthenticationEvent {
  const AuthenticationSignUpSubmitted();
}

/// Event fired when toggle between login and sign up
class AuthenticationToggleMode extends AuthenticationEvent {
  const AuthenticationToggleMode();
}