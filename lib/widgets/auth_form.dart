import '../widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File image, bool islogin, BuildContext ctx) submitfn;
  final bool isloading;
  AuthForm(this.submitfn, this.isloading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _islogin = true;
  String _userEmail = '';
  String _username = '';
  String _userpass = '';
  File _userimagefile;
  final _formKey = GlobalKey<FormState>();
  void pickedimage(File image) {
    _userimagefile = image;
  }

  void _trysubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userimagefile == null && !_islogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please pick an Image')));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitfn(_userEmail.trim(), _userpass.trim(), _username.trim(),
          _userimagefile, _islogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.black,
        elevation: 20,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_islogin) UserImagePicker(pickedimage),
                  TextFormField(
                    key: ValueKey('Email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid Email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_islogin)
                    TextFormField(
                      key: ValueKey('Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Username Must Be at Least 4 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _username = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password Must Be at Least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userpass = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isloading) CircularProgressIndicator(),
                  if (!widget.isloading)
                    RaisedButton(
                      onPressed: _trysubmit,
                      child: Text(_islogin ? 'Login' : 'Sign up'),
                    ),
                  FlatButton(
                    textColor: Theme.of(context).accentColor,
                    onPressed: () {
                      setState(() {
                        _islogin = !_islogin;
                      });
                    },
                    child: Text(
                      _islogin
                          ? 'Create New Account'
                          : 'I Already have an account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
