import 'package:equatable/equatable.dart';

/// User model representing an authenticated user
class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
  });

  /// The current user's id
  final String id;

  /// The current user's email address
  final String? email;

  /// The current user's name (display name)
  final String? name;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, email, name];
}