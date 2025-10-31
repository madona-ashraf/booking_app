import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  final String msg;

  const Unauthenticated(this.msg);
  @override
  // TODO: implement props
  List<Object?> get props => [msg];
}
