import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> createUser(String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
  }

  Future<User?> signIn(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> deleteUser() async {
    var user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception("User is not valid.");
    }

    await user.delete();
  }
}