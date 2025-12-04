// auth_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit() : super(Unauthenticated()) {
    // Check Firebase Auth state on initialization
    // Firebase Auth persists the session automatically
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Wait a bit for Firebase to initialize
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Check Firebase Auth state
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
    try {
      // Sign out from Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      
      // Sign out from Firebase
      await _auth.signOut();
      
      emit(Unauthenticated());
    } catch (e) {
      // Even if Google sign out fails, sign out from Firebase
      await _auth.signOut();
      emit(Unauthenticated());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(Loading());
      // Trigger Google sign-in flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(AuthError("Google Sign-In cancelled"));
        return;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      emit(Authenticated(email: userCredential.user?.email ?? ''));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(Loading());
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        emit(AuthError("Facebook login failed: ${result.message}"));
        return;
      }

      final accessToken = result.accessToken;
      if (accessToken == null) {
        emit(AuthError("Facebook login failed: No access token"));
        return;
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      emit(Authenticated(email: userCredential.user?.email ?? ''));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Future<void> signinYahoo() async {
  //   // Placeholder for Yahoo sign-in implementation
  //   Future<UserCredential> signInWithYahoo() async {
  //     final yahooProvider = YahooAuthProvider();
  //     if (kIsWeb) {
  //       await _auth.signInWithPopup(yahooProvider);
  //     } else {
  //       await _auth.signInWithProvider(yahooProvider);
  //     }
  //   }
  // }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
