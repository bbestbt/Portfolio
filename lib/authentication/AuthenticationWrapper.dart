import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/NewTempPage.dart';
import 'package:provider/provider.dart';

import '../EmailPasswordScreen.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print("Logged In Successfully");
      return NewTempPage();
    }

    print("Logged Out Successfully");
    return EmailPasswordScreen();
  }
}
