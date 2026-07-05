import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

/// Version temporaire (sans Firebase) du service d'authentification.
/// Même interface publique que la version finale : une fois Firebase
/// configuré (étape suivante), seul le contenu de cette classe changera —
/// aucun écran (login/register/account) n'aura besoin d'être modifié.
class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  final _authStateController = StreamController<AppUser?>.broadcast();

  bool get isLoggedIn => _currentUser != null;
  Stream<AppUser?> get authStateChanges => _authStateController.stream;

  String? _pendingPhoneNumber;

  Future<String?> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = AppUser(uid: 'local-$email', fullName: fullName, email: email);
    _authStateController.add(_currentUser);
    notifyListeners();
    return null;
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = AppUser(uid: 'local-$email', fullName: 'Client', email: email);
    _authStateController.add(_currentUser);
    notifyListeners();
    return null;
  }

  Future<void> sendPhoneCode({
    required String phoneNumber,
    required void Function() onCodeSent,
    required void Function(String error) onError,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _pendingPhoneNumber = phoneNumber;
    onCodeSent();
  }

  Future<String?> confirmPhoneCode({
    required String smsCode,
    required String fullName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = AppUser(
      uid: 'local-${_pendingPhoneNumber ?? ''}',
      fullName: fullName,
      phoneNumber: _pendingPhoneNumber,
    );
    _authStateController.add(_currentUser);
    notifyListeners();
    return null;
  }

  Future<AppUser?> fetchCurrentProfile() async => _currentUser;

  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
    notifyListeners();
  }
}
