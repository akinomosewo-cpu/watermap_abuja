import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_user.dart';

/// Result of a signup or login attempt.
enum AuthResultStatus { success, emailTaken, invalidCredentials, weakInput }

class AuthResult {
  final AuthResultStatus status;
  final AppUser? user;
  const AuthResult(this.status, [this.user]);

  bool get isSuccess => status == AuthResultStatus.success;
}

/// Local-only authentication: there is no backend, so credentials are
/// persisted in a Hive box on-device. Passwords are never stored in plain
/// text - only a salted-free SHA-256 hash, which is sufficient for a
/// single-device demo app but should be replaced with a real identity
/// provider before this app talks to a real backend.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const String _usersBoxName = 'auth_users';
  static const String _sessionBoxName = 'auth_session';
  static const String _sessionEmailKey = 'loggedInEmail';

  Box? _usersBox;
  Box? _sessionBox;

  /// Opens the Hive boxes used for auth. Must be called once, after
  /// `Hive.initFlutter()`, before any other method on this service.
  Future<void> init() async {
    _usersBox = await Hive.openBox(_usersBoxName);
    _sessionBox = await Hive.openBox(_sessionBoxName);
  }

  Box get _users => _usersBox!;
  Box get _session => _sessionBox!;

  String _hash(String value) => sha256.convert(utf8.encode(value)).toString();

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  /// Whether a user is currently marked as logged in on this device.
  bool get isLoggedIn => _session.get(_sessionEmailKey) != null;

  /// The currently logged-in user, if any.
  AppUser? get currentUser {
    final email = _session.get(_sessionEmailKey) as String?;
    if (email == null) return null;
    final record = _users.get(email) as Map?;
    if (record == null) return null;
    return AppUser.fromMap(record);
  }

  /// Registers a new local account and immediately logs the user in.
  Future<AuthResult> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    if (name.trim().isEmpty ||
        phone.trim().isEmpty ||
        normalizedEmail.isEmpty ||
        password.length < 4) {
      return const AuthResult(AuthResultStatus.weakInput);
    }
    if (_users.containsKey(normalizedEmail)) {
      return const AuthResult(AuthResultStatus.emailTaken);
    }
    final user = AppUser(name: name.trim(), phone: phone.trim(), email: normalizedEmail);
    await _users.put(normalizedEmail, {
      ...user.toMap(),
      'passwordHash': _hash(password),
    });
    await _session.put(_sessionEmailKey, normalizedEmail);
    return AuthResult(AuthResultStatus.success, user);
  }

  /// Validates credentials against the locally stored account and, on
  /// success, persists the "logged in" flag so the app can skip auth next
  /// launch.
  Future<AuthResult> logIn({required String email, required String password}) async {
    final normalizedEmail = _normalizeEmail(email);
    final record = _users.get(normalizedEmail) as Map?;
    if (record == null || record['passwordHash'] != _hash(password)) {
      return const AuthResult(AuthResultStatus.invalidCredentials);
    }
    await _session.put(_sessionEmailKey, normalizedEmail);
    return AuthResult(AuthResultStatus.success, AppUser.fromMap(record));
  }

  Future<void> logOut() async {
    await _session.delete(_sessionEmailKey);
  }
}
