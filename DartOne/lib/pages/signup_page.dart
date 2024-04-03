import 'package:flutter/material.dart';
import 'package:game_review/pages/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart' as app_user;
import '../provider/auth_provider.dart' as app_auth_provider;
import '../provider/data_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _favoriteGenreController = TextEditingController();
  final _favoriteGameController = TextEditingController();
  final _ageController = TextEditingController();

  final _authProvider = app_auth_provider.AuthProvider();
  final _dataProvider = DataProvider();

  Future<void> _register() async {
    User? user;
    String errorMessage = 'Error';

    try {
      user = await _authProvider.createUser(_emailController.text,
                                            _passwordController.text);

      _dataProvider.addUser(app_user.User(user!.uid, user.email ?? "",
          _nameController.text, _favoriteGenreController.text,
          _favoriteGameController.text,
          int.tryParse(_ageController.text) ?? 0));

      final currentContext = context;
      Future.microtask(() {
        Navigator.of(currentContext).push(MaterialPageRoute(builder: (context) => const SignInPage()));
      });
      return;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'Password it too weak.';
      }
      else if (e.code == 'email-already-in-use') {
        errorMessage = 'Account with this e-mail already exists.';
      }
    } catch (e) {
      errorMessage = 'Error';
    }

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Page'),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _favoriteGenreController,
              decoration: const InputDecoration(labelText: 'Favorite genre'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _favoriteGameController,
              decoration: const InputDecoration(labelText: 'Favorite game'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}