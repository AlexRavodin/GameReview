import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {

  Future<User?> createUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Пароль слишком слабый.');
      } else if (e.code == 'email-already-in-use') {
        print('Аккаунт для этого email уже существует.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Пользователь с таким email не найден.');
      } else if (e.code == 'wrong-password') {
        print('Неверный пароль.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}