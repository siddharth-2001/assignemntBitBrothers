import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './providers/auth.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User()),
      ],
      child: Consumer<User>(
        builder: (context, user, ch) {
          user.autoLogin();
          return MaterialApp(
            title: 'bitAssign',
            theme:  ThemeData(
              primarySwatch: Colors.deepPurple
            ),
            home: user.isAuth() ? HomeScreen(): AuthScreen(),
            routes: {
              AuthScreen.routeName: (context) => AuthScreen(),
              HomeScreen.routeName: (context) => HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
