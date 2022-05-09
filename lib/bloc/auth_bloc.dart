import 'dart:developer';

import 'package:ad_champagne_test_task/bloc/auth_event.dart';
import 'package:ad_champagne_test_task/bloc/auth_state.dart';
import 'package:ad_champagne_test_task/pages/loginPage.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../navigation/navigations.dart';
import '../pages/homePage.dart';
import '../user model/model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthLogIn>(_onAuthLoginEvent);
    on<AuthRegister>(_onAuthRegisterEvent);
    on<AuthLogOut>(_onAuthLogOutEvent);
    on<AuthResetPassword>(_onAuthReset);
    on<AuthDeleteUser>(_onDeleteUser);
    on<AuthInitUser>(_onAuthInitUser);
  }
  final _navi = CustomNavigations();

  Box userBox = Hive.box<User>('users');
  Box stateBox = Hive.box<AuthState>('authStates');

  Future<void> _onAuthLoginEvent(
      AuthLogIn event, Emitter<AuthState> emitter) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      try {
        User user = userBox.get(event.email);
        if (user.password == event.password) {
          emitter(state.copyWith(email: user.email, password: user.password));
          stateBox.put(event.email, state);
          _navi.getIn(widget: const HomePage(), context: event.context);
          event.onSuccess();
        } else {
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(content: Text('неправильный пароль, соре')));
        }
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
            content: Row(
          children: [
            Text('Таких не знаем...'),
            TextButton(
                onPressed: () {
                  event.onErrorCallback();
                },
                child: Text('Познакомимся? ;)'))
          ],
        )));
      }
    });
  }

  Future<void> _onAuthRegisterEvent(
      AuthRegister event, Emitter<AuthState> emitter) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      try {
        var _localuser = userBox.get(event.email);
        if (_localuser == null) {
          User user = User(
              email: event.email, password: event.password, name: event.name);
          userBox.put(event.email, user);
          emitter(state.copyWith(email: event.email, password: event.password));
          stateBox.put(event.email, state);
          _navi.getIn(widget: const HomePage(), context: event.context);
          event.onSuccess();
        } else {
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(content: Text('Такой емейл уже существует')));
        }
      } on Exception catch (e) {
        log(e.toString());
        event.onError();
      }
    });
  }

  Future<void> _onAuthInitUser(
      AuthInitUser event, Emitter<AuthState> emitter) async {
    try {
      print("State box isn't empty: ${stateBox.isNotEmpty}");
      if (stateBox.isNotEmpty) {
        AuthState _state = stateBox.getAt(0);
        if (_state.email.isNotEmpty) {
          emitter(
              state.copyWith(email: _state.email, password: _state.password));
          _navi.getIn(widget: const HomePage(), context: event.context);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onAuthLogOutEvent(
      AuthLogOut event, Emitter<AuthState> emitter) async {
    stateBox.delete(state.email);
    emitter(state.copyWith(email: '', password: ''));
    _navi.getOut(widget: const LoginPage(), context: event.context);
  }

  Future<void> _onAuthReset(
      AuthResetPassword event, Emitter<AuthState> emitter) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      try {
        User user = userBox.get(event.email);
        User _newUser = User(
            name: user.name, email: event.email, password: event.newPassword);
        userBox.put(user.email, _newUser);
        emitter(
            state.copyWith(email: event.email, password: event.newPassword));
        ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Пароль успешно обновлен')));
        event.onSuccess();
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Такого пользователя не существует')));
        event.onError();
      }
    });
  }

  Future<void> _onDeleteUser(
      AuthDeleteUser event, Emitter<AuthState> emitter) async {
    try {
      userBox.delete(event.user.email);
      emitter(state.copyWith(email: '', password: ''));
      stateBox.delete(event.user.email);
      _navi.getOut(widget: const LoginPage(), context: event.context);
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text('Что-то очень пошло не так')));
    }
  }
}
