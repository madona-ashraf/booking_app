import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // set display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
    } on FirebaseAuthException catch (e) {
      // normalize message
      throw Exception(e.message ?? 'Registration failed');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // optional: get display name for current signed-in user if email matches
  String? nameFor(String email) {
    final user = _auth.currentUser;
    if (user == null) return null;
    if (user.email == email) return user.displayName;
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
