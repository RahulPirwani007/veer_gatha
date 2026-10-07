import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());

      return null; // success -> error nahi hai
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return "Kuch galat ho gaya, dubara try karo";
    }
  }


  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return "Kuch galat ho gaya, dubara try karo";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapError(String code) {
    switch (code) {
      case "email-already-in-use":
        return "Ye email already registered hai";
      case "invalid-email":
        return "Email format sahi nahi hai";
      case "weak-password":
        return "Password bahut weak hai";
      case "user-not-found":
        return "Account nahi mila, pehle signup karo";
      case "wrong-password":
      case "invalid-credential":
        return "Email ya password galat hai";
      default:
        return "Authentication fail ho gaya: $code";
    }
  }
}
