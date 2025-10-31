import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(Authenticated(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(Unauthenticated(e.message ?? 'Authentication failed'));
    } catch (e) {
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      emit(Authenticated(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(Unauthenticated(e.message ?? 'Registration failed'));
    } catch (e) {
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(Unauthenticated('Logged out'));
  }
}
