import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user != null) {
        return credentials.user;
      } else {
        throw AuthException("Could not find authenticated user");
      }
    } catch (error) {
      throw AuthException(error.toString());
    }
  }

  Future<User?> checkAuthStatus() async {
    return _auth.currentUser;
  }

  Stream<User?> listenAuthStatus() {
    return _auth.authStateChanges().map((user) {
      // debugPrint("Auth status changed [AuthService] $user");
      return user;
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
