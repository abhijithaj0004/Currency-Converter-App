import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

/// Authentication mode enum
enum AuthenticationMode { login, signUp }

/// Email validation error
enum EmailValidationError { empty, invalid }

/// Password validation error
enum PasswordValidationError { empty, tooShort }

/// Email input field
class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) return EmailValidationError.empty;
    return _emailRegExp.hasMatch(value!) ? null : EmailValidationError.invalid;
  }
}

/// Password input field
class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) return PasswordValidationError.empty;
    return value!.length >= 6 ? null : PasswordValidationError.tooShort;
  }
}

/// Authentication state
class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.mode = AuthenticationMode.login,
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  /// Current authentication mode (login or sign up)
  final AuthenticationMode mode;
  
  /// Form submission status
  final FormzSubmissionStatus status;
  
  /// Email input field
  final Email email;
  
  /// Password input field
  final Password password;
  
  /// Whether the form is valid
  final bool isValid;
  
  /// Error message if any
  final String? errorMessage;

  /// Copy with method for state updates
  AuthenticationState copyWith({
    AuthenticationMode? mode,
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
    String? errorMessage,
  }) {
    return AuthenticationState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        status,
        email,
        password,
        isValid,
        errorMessage,
      ];
}