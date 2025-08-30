import 'package:equatable/equatable.dart';
import 'user.dart';

/// Represents the authentication status of the application
enum AppStatus {
  /// User authentication status is unknown
  unknown,
  
  /// User is authenticated
  authenticated,
  
  /// User is not authenticated
  unauthenticated,
}

/// State of the application
class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
  });

  /// Unknown authentication state
  const AppState.unknown() : this._(status: AppStatus.unknown);

  /// Authenticated state with user
  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  /// Unauthenticated state
  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  /// Current authentication status
  final AppStatus status;

  /// Current authenticated user
  final User user;

  @override
  List<Object> get props => [status, user];
}