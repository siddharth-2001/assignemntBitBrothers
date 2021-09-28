import 'package:bit_assign/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


enum AuthMode { Login, Register }

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map formData = {
    'email': '',
    'password': '',
  };

  final TextEditingController passController = TextEditingController();

  AuthMode mode = AuthMode.Login;

  void saveForm(context) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (mode == AuthMode.Login)
      Provider.of<User>(context, listen: false)
          .login(formData['email'], formData['password'])
          .then((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    else
      Provider.of<User>(context, listen: false)
          .register(formData['email'], formData['password'])
          .then((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height*0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white
        
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        mode == AuthMode.Login
            ? Text(
                'Log In',
                style: theme.textTheme.headline6,
              )
            : Text(
                'Register',
                style: theme.textTheme.headline6,
              ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'email'),
                  validator: (value) {
                    if (!value!.contains('@') || !value.contains('.com'))
                      return 'Enter a valid email';
                  },
                  onSaved: (value) {
                    formData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'password'),
                  controller: passController,
                  onSaved: (value) {
                    formData['password'] = value;
                  },
                ),
                if (mode == AuthMode.Register)
                  TextFormField(
                    decoration: InputDecoration(hintText: 'confirm password'),
                    validator: (value) {
                      if (value != passController.text)
                        return 'Passwords do not match';
                    },
                  ),
              ],
            )),
            SizedBox(
              height: 16,
            ),
        ElevatedButton(
          onPressed: () {
            saveForm(context);
          },
          child: Text('Submit'),
        ),
        mode == AuthMode.Register
            ? Row(
                children: [
                  Text('Already a member?'),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          mode = AuthMode.Login;
                        });
                      },
                      child: Text('Log In')),
                ],
              )
            : Row(
                children: [
                  Text('Not a member?'),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          mode = AuthMode.Register;
                        });
                      },
                      child: Text('Register')),
                ],
              )
      ]),
    );
  }
}
