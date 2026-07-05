import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

/// Centralise toute la logique d'authentification (e-mail + téléphone)
/// et la création automatique du profil client dans Firestore
/// (collection "users").
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get firebaseUser => _auth.currentUser;
  bool get isLoggedIn => firebaseUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Conservé le temps de la vérification du code SMS reçu.
  String? _phoneVerificationId;

  // ---------- E-MAIL + MOT DE PASSE ----------

  Future<String?> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createUserProfile(uid: cred.user!.uid, fullName: fullName, email: email);
      return null; // succès
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    }
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    }
  }

  // ---------- TÉLÉPHONE (SMS) ----------

  /// Envoie le code SMS au numéro fourni (format international, ex: +23566xxxxxx).
  /// [onCodeSent] est appelé dès que le code a été envoyé, pour afficher
  /// l'écran de saisie du code à l'utilisateur.
  Future<void> sendPhoneCode({
    required String phoneNumber,
    required void Function() onCodeSent,
    required void Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Sur certains téléphones Android, la vérification est automatique.
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(_mapAuthError(e));
      },
      codeSent: (String verificationId, int? resendToken) {
        _phoneVerificationId = verificationId;
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _phoneVerificationId = verificationId;
      },
    );
  }

  /// Valide le code reçu par SMS et connecte l'utilisateur.
  Future<String?> confirmPhoneCode({
    required String smsCode,
    required String fullName,
  }) async {
    if (_phoneVerificationId == null) {
      return 'Aucune demande de code en cours. Veuillez recommencer.';
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _phoneVerificationId!,
        smsCode: smsCode,
      );
      final result = await _auth.signInWithCredential(credential);
      // Crée le profil s'il n'existe pas encore (premier login).
      final doc = await _db.collection('users').doc(result.user!.uid).get();
      if (!doc.exists) {
        await _createUserProfile(
          uid: result.user!.uid,
          fullName: fullName,
          phoneNumber: result.user!.phoneNumber,
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    }
  }

  // ---------- COMMUN ----------

  Future<void> _createUserProfile({
    required String uid,
    required String fullName,
    String? email,
    String? phoneNumber,
  }) {
    final user = AppUser(uid: uid, fullName: fullName, email: email, phoneNumber: phoneNumber);
    return _db.collection('users').doc(uid).set(user.toMap());
  }

  Future<AppUser?> fetchCurrentProfile() async {
    final uid = firebaseUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  Future<void> signOut() => _auth.signOut();

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cette adresse e-mail est déjà utilisée.';
      case 'invalid-email':
        return 'Adresse e-mail invalide.';
      case 'weak-password':
        return 'Le mot de passe est trop faible (6 caractères minimum).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou mot de passe incorrect.';
      case 'invalid-phone-number':
        return 'Numéro de téléphone invalide.';
      case 'invalid-verification-code':
        return 'Code de vérification incorrect.';
      default:
        return e.message ?? 'Une erreur est survenue. Veuillez réessayer.';
    }
  }
}
