part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {}

class Loading extends AuthState {}

class Authenticated extends AuthState {
  final String email;
  Authenticated({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
