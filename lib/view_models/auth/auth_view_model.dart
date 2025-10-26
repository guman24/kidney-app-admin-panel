import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/services/auth_service.dart';
import 'package:kidney_admin/services/oliver_service.dart';
import 'package:kidney_admin/view_models/auth/auth_state.dart';

final authViewModel = NotifierProvider(() => AuthViewModel());

class AuthViewModel extends Notifier<AuthState> with ChangeNotifier {
  @override
  AuthState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthStatus();
      listenAuthState();
    });

    return AuthState();
  }

  void checkAuthStatus() async {
    state = state.copyWith(authStatus: ActionStatus.loading);
    try {
      final authUser = await ref.read(authServiceProvider).checkAuthStatus();
      final currentOliver = await ref
          .read(oliverServiceProvider)
          .getOliverById(authUser?.uid ?? "");
      state = state.copyWith(
        authUser: authUser,
        currentOliver: currentOliver,
        authStatus: ActionStatus.success,
      );
    } catch (error) {
      state = state.copyWith(
        authStatus: ActionStatus.failed,
        authError: error.toString(),
      );
    }
    notifyListeners();
  }

  void listenAuthState() {
    final authUserStream = ref.read(authServiceProvider).listenAuthStatus();
    authUserStream.listen((data) async {
      // change auth user data
      // debugPrint("Auth status changed in vm $data");
      if (data == null) {
        state = state.copyWithNullAuthUser();
      } else {
        if (state.currentOliver?.id != data.uid ||
            state.currentOliver == null) {
          final currentOliver = await ref
              .read(oliverServiceProvider)
              .getOliverById(data.uid);
          state = state.copyWith(currentOliver: currentOliver);
        }
        state = state.copyWith(authUser: data);
      }
    });
    // notifyListeners();
  }

  Future<void> login(
    String email,
    String password, {
    Completer? completer,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authUser = await ref
          .read(authServiceProvider)
          .login(email, password);
      if (authUser != null) {
        final currentOliver = await ref
            .read(oliverServiceProvider)
            .getOliverById(authUser.uid);
        state = state.copyWith(currentOliver: currentOliver);
        completer?.complete(currentOliver);
      } else {
        completer?.completeError("Something went wrong");
        state = state.copyWith(authError: "Something went wrong");
      }
    } catch (error) {
      state = state.copyWith(authError: error.toString());
      completer?.completeError(error.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    notifyListeners();
  }
}
