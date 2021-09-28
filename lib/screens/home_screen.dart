import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<User>(context, listen: false).userMail;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('You are now logged in with the email: $email '),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<User>(context, listen: false).logout();
                    Navigator.of(context).pushReplacementNamed('/auth');
                  },
                  child: Text('Logout'))
            ]),
      ),
    );
  }
}
