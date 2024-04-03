import 'package:flutter/material.dart';

import '../model/user.dart';
import '../provider/data_provider.dart';
import '../provider/auth_provider.dart';
import '../pages/signin_page.dart';


class UserPage extends StatefulWidget {
  final String userId;

  const UserPage(this.userId, {super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final DataProvider _dataProvider = DataProvider();
  final AuthProvider _authProvider = AuthProvider();
  User? _user;

  late TextEditingController _nameController;
  late TextEditingController _favoriteGenreController;
  late TextEditingController _favoriteGameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();

    var _ = _dataProvider.loadUser(widget.userId).then((result)
    {
      if (mounted)
        {
          setState(() {
            _user = result;

            _nameController = TextEditingController(text: _user!.name);
            _favoriteGameController = TextEditingController(text: _user!.favoriteGame);
            _favoriteGenreController = TextEditingController(text: _user!.favoriteGenre);
            _ageController = TextEditingController(text: _user!.age.toString());

          });
        }
    }
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Can not load user."),
          backgroundColor: Colors.red,
        ),
      );
    }
    );
  }

  @override
  void dispose()
  {
    _nameController.dispose();
    _favoriteGenreController.dispose();
    _favoriteGameController.dispose();
    _ageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                try {
                  _dataProvider.updateUser(
                      User(widget.userId, _user!.email, _nameController.text,
                          _favoriteGenreController.text,
                          _favoriteGameController.text,
                          int.tryParse(_ageController.text) ?? _user!.age));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("User is updated."),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Can not update user."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                try {
                  _dataProvider.deleteUser(widget.userId);
                  _authProvider.deleteUser();

                  final currentContext = context;
                  Future.microtask(() {
                    Navigator.of(currentContext).push(MaterialPageRoute(builder: (context) => const SignInPage()));
                  });
                }
                catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Can not delete user."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.dangerous_rounded),
              onPressed: () {
                try {
                  _authProvider.signOut();

                  final currentContext = context;
                  Future.microtask(() {
                    Navigator.of(currentContext).push(MaterialPageRoute(builder: (context) => const SignInPage()));
                  });
                }
                catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Can not sign out."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _user!.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _favoriteGenreController,
                decoration: const InputDecoration(
                  labelText: 'Favorite Genre',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _favoriteGameController,
                decoration: const InputDecoration(
                  labelText: 'Favorite Game',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}