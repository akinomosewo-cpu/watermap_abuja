// Unit tests for the local-only auth flow: signup persists credentials in
// Hive, login validates them, and the "logged in" flag lets returning users
// skip straight to the home screen.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:watermap_abuja/domain/services/auth_service.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('watermap_auth_test');
    Hive.init(tempDir.path);
    await AuthService.instance.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('sign up creates an account and logs the user in', () async {
    final result = await AuthService.instance.signUp(
      name: 'Amaka Obi',
      phone: '08012345678',
      email: 'Amaka@Example.com',
      password: 'secret1',
    );

    expect(result.isSuccess, isTrue);
    expect(result.user?.email, 'amaka@example.com');
    expect(AuthService.instance.isLoggedIn, isTrue);
    expect(AuthService.instance.currentUser?.name, 'Amaka Obi');
  });

  test('sign up rejects a duplicate email', () async {
    await AuthService.instance.signUp(
      name: 'Amaka Obi',
      phone: '08012345678',
      email: 'amaka@example.com',
      password: 'secret1',
    );
    final result = await AuthService.instance.signUp(
      name: 'Someone Else',
      phone: '08087654321',
      email: 'amaka@example.com',
      password: 'other123',
    );

    expect(result.status, AuthResultStatus.emailTaken);
  });

  test('log in succeeds with correct credentials and fails otherwise',
      () async {
    await AuthService.instance.signUp(
      name: 'Amaka Obi',
      phone: '08012345678',
      email: 'amaka@example.com',
      password: 'secret1',
    );
    await AuthService.instance.logOut();
    expect(AuthService.instance.isLoggedIn, isFalse);

    final wrongPassword = await AuthService.instance
        .logIn(email: 'amaka@example.com', password: 'wrong');
    expect(wrongPassword.status, AuthResultStatus.invalidCredentials);
    expect(AuthService.instance.isLoggedIn, isFalse);

    final correct = await AuthService.instance
        .logIn(email: 'amaka@example.com', password: 'secret1');
    expect(correct.isSuccess, isTrue);
    expect(AuthService.instance.isLoggedIn, isTrue);
  });

  test('log out clears the persisted session', () async {
    await AuthService.instance.signUp(
      name: 'Amaka Obi',
      phone: '08012345678',
      email: 'amaka@example.com',
      password: 'secret1',
    );
    expect(AuthService.instance.isLoggedIn, isTrue);

    await AuthService.instance.logOut();

    expect(AuthService.instance.isLoggedIn, isFalse);
    expect(AuthService.instance.currentUser, isNull);
  });
}
