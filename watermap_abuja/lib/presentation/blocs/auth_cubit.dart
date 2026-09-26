import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/app_user.dart';
import '../../domain/services/auth_service.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Initial state while the persisted session is being checked.
class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthAuthenticated extends AuthState {
  final AppUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user.email];
}

class AuthUnauthenticated extends AuthState {
  final String? error;
  const AuthUnauthenticated({this.error});
  @override
  List<Object?> get props => [error];
}

/// Thin bloc wrapper around [AuthService] so the UI can react to
/// login/signup/logout via `flutter_bloc`, consistent with the rest of the
/// app's state management.
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  AuthCubit({AuthService? authService})
      : _authService = authService ?? AuthService.instance,
        super(const AuthUnknown());

  /// Checks whether a session already exists (returning user flow).
  void checkSession() {
    final user = _authService.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final result = await _authService.signUp(
        name: name, phone: phone, email: email, password: password);
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.user!));
    } else {
      emit(AuthUnauthenticated(error: _messageFor(result.status)));
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    final result = await _authService.logIn(email: email, password: password);
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.user!));
    } else {
      emit(AuthUnauthenticated(error: _messageFor(result.status)));
    }
  }

  Future<void> logOut() async {
    await _authService.logOut();
    emit(const AuthUnauthenticated());
  }

  String _messageFor(AuthResultStatus status) {
    switch (status) {
      case AuthResultStatus.emailTaken:
        return 'An account with that email already exists';
      case AuthResultStatus.invalidCredentials:
        return 'Incorrect email or password';
      case AuthResultStatus.weakInput:
        return 'Please fill every field with a valid value (password min. 4 characters)';
      case AuthResultStatus.success:
        return '';
    }
  }
}
