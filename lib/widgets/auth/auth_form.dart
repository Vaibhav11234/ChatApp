import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String userName,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); //keyboardview gone

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
          _userEmail
              .trim(), //trim() remove blank places after or before the email written
          _userName.trim(),
          _userPassword.trim(),
          _userImageFile,
          _isLogin,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin) UserImagePicker(_pickedImage),
                      TextFormField(
                        key: ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email address'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please Enter a valid email address.';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return 'Enter user name of minimum 4 letters';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        RaisedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                        ),
                      if (!widget.isLoading)
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'I already have an account'),
                          textColor: Theme.of(context).primaryColor,
                        ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
