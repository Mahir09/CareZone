import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/auth.dart';
import '../constants.dart';
import '../widgets/custom_exceptions.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'userName': '',
  };

  var _isLoading = false;
  bool submitValid = true;
  bool _passwordVisible = false;

  final TextEditingController _emailcontroller = TextEditingController();

  void _displayErr(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error occurred'),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).signIn(
            _authData['email'], _authData['password'], _authData['userName']);
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email'], _authData['password'], _authData['userName']);
      }
    } on CustomExceptions catch (error) {
      var errMessage = 'Could not authenticate. Please try again!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errMessage = 'Email already exists';
      } else {
        errMessage = 'Invalid Credentials';
      }
      _displayErr(errMessage);
    } catch (error) {
      const errMessage = 'Authentication failed. Please try again';
      _displayErr(errMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/signin.jpg',
                  width: double.infinity, height: 200.0),
              SizedBox(height: 2.0),
              Text(
                'CareZone',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
              SizedBox(width: double.infinity, height: 35.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailcontroller,
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@"))
                          return "Please enter a valid email";
                        else
                          return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.email_outlined),
                        labelText: 'Enter Your Email Id',
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                    SizedBox(width: double.infinity, height: 10.0),
                    if (_authMode == AuthMode.Signup)
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter a valid username";
                            else
                              return null;
                          },
                          onSaved: (value) {
                            _authData['userName'] = value;
                          },
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.drive_file_rename_outline),
                            labelText: 'Enter Your Username',
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          )),
                    SizedBox(width: double.infinity, height: 5.0),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please enter a valid password";
                        else
                          return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.lock_outlined),
                        labelText: 'Enter Your Password',
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: double.infinity, height: 20.0),
                    if (_isLoading) CircularProgressIndicator(),
                    if (!_isLoading)
                      FlatButton(
                        onPressed:
                            (_authMode == AuthMode.Signup && !submitValid)
                                ? null
                                : _submit,
                        child: Text(_authMode == AuthMode.Login
                            ? 'Login'
                            : 'Create Account'),
                        textColor: Colors.white,
                        color: kSecondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        disabledColor: Colors.grey[400],
                      ),
                    SizedBox(width: double.infinity, height: 20.0),
                    Text(_authMode == AuthMode.Login
                        ? 'Not a User?'
                        : 'Already a User?'),
                    SizedBox(width: double.infinity, height: 20.0),
                    FlatButton(
                      onPressed: _switchAuthMode,
                      child: Text(_authMode == AuthMode.Login
                          ? 'Create New Account'
                          : 'I already have an account'),
                      color: kSecondary,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
