import 'package:flutter/cupertino.dart';

import '../user model/model.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthLogIn extends AuthEvent {
  final String email;
  final String password;
  final Function onSuccess;
  final BuildContext context;
  final Function onErrorCallback;
  const AuthLogIn({
    required this.email,
    required this.password,
    required this.onSuccess,
    required this.context,
    required this.onErrorCallback,
  });
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final Function onSuccess;
  final Function onError;
  final BuildContext context;
  AuthRegister({
    required this.email,
    required this.password,
    required this.name,
    required this.onSuccess,
    required this.onError,
    required this.context,
  });
}

class AuthLogOut extends AuthEvent {
  final BuildContext context;
  AuthLogOut({
    required this.context,
  });
}

class AuthResetPassword extends AuthEvent {
  final String email;
  final String newPassword;
  final BuildContext context;
  final Function onSuccess;

  final Function onError;
  AuthResetPassword({
    required this.context,
    required this.email,
    required this.newPassword,
    required this.onSuccess,
    required this.onError,
  });
}

class AuthDeleteUser extends AuthEvent {
  final User user;
  final BuildContext context;
  AuthDeleteUser({
    required this.user,
    required this.context,
  });
}

class AuthInitUser extends AuthEvent {
  final BuildContext context;
  AuthInitUser({
    required this.context,
  });
}
