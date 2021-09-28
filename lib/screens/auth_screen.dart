import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_form.dart';
import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    Provider.of<User>(context, listen: false).autoLogin();
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: Text('Auth'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [AuthForm()],
        ),
      ),
    );
  }
}
