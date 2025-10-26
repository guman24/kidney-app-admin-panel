import 'package:firebase_auth/firebase_auth.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/oliver.dart';

class AuthState {
  final ActionStatus authStatus;
  final User? authUser;
  final bool isLoading;
  final Oliver? currentOliver;
  final String? authError;

  AuthState({
    this.authStatus = ActionStatus.initial,
    this.authUser,
    this.isLoading = false,
    this.currentOliver,
    this.authError,
  });

  AuthState copyWith({
    ActionStatus? authStatus,
    User? authUser,
    bool? isLoading,
    Oliver? currentOliver,
    String? authError,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      authUser: authUser ?? this.authUser,
      isLoading: isLoading ?? this.isLoading,
      currentOliver: currentOliver ?? this.currentOliver,
      authError: authError ?? this.authError,
    );
  }

  AuthState copyWithNullAuthUser() {
    return AuthState(
      currentOliver: null,
      authUser: null,
      authStatus: authStatus,
      isLoading: isLoading,
      authError: authError,
    );
  }

  @override
  String toString() => "Auth State => $authStatus $isLoading $authError";
}
