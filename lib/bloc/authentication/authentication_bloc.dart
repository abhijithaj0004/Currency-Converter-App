import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../services/authentication_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

/// BLoC that manages authentication form state
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState()) {
    on<AuthenticationEmailChanged>(_onEmailChanged);
    on<AuthenticationPasswordChanged>(_onPasswordChanged);
    on<AuthenticationLoginSubmitted>(_onLoginSubmitted);
    on<AuthenticationSignUpSubmitted>(_onSignUpSubmitted);
    on<AuthenticationToggleMode>(_onToggleMode);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(
    AuthenticationEmailChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(
    AuthenticationPasswordChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
        errorMessage: null,
      ),
    );
  }

  void _onLoginSubmitted(
    AuthenticationLoginSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (!state.isValid) return;
    
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'An unknown error occurred.',
        ),
      );
    }
  }

  void _onSignUpSubmitted(
    AuthenticationSignUpSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (!state.isValid) return;
    
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'An unknown error occurred.',
        ),
      );
    }
  }

  void _onToggleMode(
    AuthenticationToggleMode event,
    Emitter<AuthenticationState> emit,
  ) {
    final newMode = state.mode == AuthenticationMode.login
        ? AuthenticationMode.signUp
        : AuthenticationMode.login;
    
    emit(
      state.copyWith(
        mode: newMode,
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }
}