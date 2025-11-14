// auth_cubit.dart
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit() : super(Unauthenticated()) {
    // Check Firebase Auth state on initialization
    // Firebase Auth persists the session automatically
    _checkAuthState();

    // Also listen to auth state changes
    _authStateSubscription = _auth.authStateChanges().listen((user) {
      if (user != null && user.email != null) {
        emit(Authenticated(email: user.email!));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  void _checkAuthState() {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      emit(Authenticated(email: user.email!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(Authenticated(email: email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(Authenticated(email: email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(Unauthenticated());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
