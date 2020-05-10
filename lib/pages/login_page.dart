import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home_page.dart';
import '../net/api.dart';
import '../utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // https://flutter.dev/docs/cookbook/forms/validation
  // https://www.developerlibs.com/2018/09/flutter-form-validation-in-flutter.html
  // https://www.filledstacks.com/snippet/form-validation-in-flutter-for-beginners/
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username, password;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final usernameTextFormField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: 'admin',
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        username = val;
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Please enter username';
        }
        return null;
      },
    );

    final passwordTextFormField = TextFormField(
      autofocus: false,
      initialValue: '123456',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        password = val;
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            bool isSuccess = false;
            try {
              isSuccess = await API.instance.login(context, username, password);
              debugPrint('isSuccess: $isSuccess');
              if (isSuccess) {
                Navigator.of(context).pushReplacementNamed(HomePage.tag);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MessageDialog(
                      title: 'Failed',
                      content: 'Login Failed',
                    );
                  },
                );
              }
            } catch (e) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Login Failed with ${e.toString()}'),
              ));
            }
          } else {
            // validation error
            setState(() {
              _validate = true;
            });
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password123?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () async {},
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) => Center(
          child: Form(
            key: _formKey,
            autovalidate: _validate,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                usernameTextFormField,
                SizedBox(height: 8.0),
                passwordTextFormField,
                SizedBox(height: 24.0),
                loginButton,
                forgotLabel,
              ],
            ),
          ),
        ),
      ),
    );
  }
}