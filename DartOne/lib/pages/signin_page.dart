import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:game_review/pages/games_page.dart';
import 'package:game_review/pages/signup_page.dart';
import '../provider/auth_provider.dart' as app_auth_provider;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authProvider = app_auth_provider.AuthProvider();

  Future<void> _login(BuildContext context) async {
    User? user;
    String errorMessage = "Error.";

    try {
      user = await _authProvider.signIn(_emailController.text,
          _passwordController.text);
      
      final currentContext = context;
      Future.microtask(() {
        Navigator.of(currentContext).push(MaterialPageRoute(builder: (context) => GamesListPage(
            userId: user!.uid
        )));
      });

      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = "Account with this e-mail doesn't exists.";
      }
      else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password.';
      }
    } catch (e) {
      errorMessage = "Error.";
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { _login(context); },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Go To Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
