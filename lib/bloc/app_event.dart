import 'package:equatable/equatable.dart';
import '../user.dart';

/// Base class for all app events
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

/// Event fired when the user authentication status changes
class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

/// Event fired when the user requests to log out
class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}
