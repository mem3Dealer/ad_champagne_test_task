import 'dart:io';
import 'package:ad_champagne_test_task/bloc/auth_bloc.dart';
import 'package:ad_champagne_test_task/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final authBloc = GetIt.I.get<AuthBloc>();

  String _state = 'login';
  @override
  void initState() {
    _state = 'login';
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  void changePageStatus(String newstat) {
    setState(() {
      _state = newstat;
    });
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    authBloc.add(AuthInitUser(context: context));
    return Scaffold(
        appBar: AppBar(
          title: const Text('адШампань'),
        ),
        body: SafeArea(
            child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _state == 'login'
                        ? loginList()
                        : _state == 'register'
                            ? registerList()
                            : _state == 'reset'
                                ? resetList()
                                : []),
              ],
            ),
          ),
        )));
  }

  List<Widget> loginList() {
    final _theme = Theme.of(context);
    return [
      Text(
        'Чьих будешь?',
        style: _theme.textTheme.headline1,
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: emailField(),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
        child: passwordField(hintText: 'Пароль'),
      ),
      myDebounceButton(),
      myButton(newStatus: 'register', name: 'Познакомимся?'),
      myButton(newStatus: 'reset', name: 'Забыл пароль?')
    ];
  }

  void _logIn() {
    authBloc.add(AuthLogIn(
      context: context,
      email: _email.text,
      password: _password.text,
      onSuccess: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
        _email.clear();
        _password.clear();
      },
      onErrorCallback: () => changePageStatus('register'),
    ));
  }

  void _register() {
    authBloc.add(AuthRegister(
        password: _password.text,
        email: _email.text,
        name: _name.text,
        context: context,
        onError: () {},
        onSuccess: () {
          _email.clear();
          _password.clear();
          _name.clear();
        }));
  }

  void _resetPass() {
    authBloc.add(AuthResetPassword(
        email: _email.text,
        newPassword: _password.text,
        context: context,
        onSuccess: () {
          changePageStatus('login');
        },
        onError: () {
          _email.clear();
          _password.clear();
        }));
  }

  Widget myDebounceButton() {
    return TapDebouncer(
      cooldown: Duration(milliseconds: 1000),
      waitBuilder: (BuildContext cobntext, Widget child) {
        return const CircularProgressIndicator(
          color: Color(0xffE14D43),
        );
      },
      onTap: () async {
        bool isOnline = await hasNetwork();
        if (isOnline) {
          _state == 'login'
              ? _logIn()
              : _state == 'register'
                  ? _register()
                  : _state == 'reset'
                      ? _resetPass()
                      : {};
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Нет интернет соединения...')));
        }
      },
      builder: (BuildContext context, TapDebouncerFunc? onTap) {
        return ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                onTap!();
              }
            },
            child: Text(_state == 'login'
                ? 'Войти'
                : _state == 'register'
                    ? 'Создаемся'
                    : _state == 'reset'
                        ? 'Сбросить пароль'
                        : ''));
      },
    );
  }

  List<Widget> registerList() {
    final _theme = Theme.of(context);
    return [
      Text(
        'Давай знакомиться',
        style: _theme.textTheme.headline1,
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
            child: nameField(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: emailField(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: passwordField(hintText: 'Пароль'),
          ),
        ],
      ),
      myDebounceButton(),
      myButton(newStatus: 'login', name: 'У меня уже есть аккаунт'),
      myButton(newStatus: 'reset', name: 'Забыл пароль? Сбросим')
    ];
  }

  List<Widget> resetList() {
    final _theme = Theme.of(context);
    return [
      Text(
        'Сменим пароль?',
        style: _theme.textTheme.headline1,
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: emailField(),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
        child: passwordField(hintText: 'Новый пароль'),
      ),
      myDebounceButton(),
      myButton(newStatus: 'login', name: 'Вспомнил пароль'),
      myButton(newStatus: 'register', name: 'Пожалуй, начну сначала...')
    ];
  }

  TextButton myButton({required String newStatus, required String name}) {
    return TextButton(
        onPressed: () {
          changePageStatus(newStatus);
          _email.clear();
          _password.clear();
        },
        child: Text(name));
  }

  Widget emailField() {
    return TextFormField(
      cursorColor: const Color.fromARGB(255, 26, 25, 25),
      decoration: const InputDecoration(hintText: "Емейл", counter: Offstage()),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Ну куда без мыла-то';
        } else if (!val.contains('@')) {
          return 'Мыла без собаки не бывает!';
        } else if (!val.contains('.')) {
          return 'а домен-то какой??';
        }
        return null;
      },
      maxLength: 20,
      autocorrect: false,
      enableSuggestions: false,
      controller: _email,
    );
  }

  Widget nameField() {
    return TextFormField(
      cursorColor: Color.fromARGB(255, 26, 25, 25),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Имя всё же нужно указать';
        }
        return null;
      },
      maxLength: 10,
      decoration: const InputDecoration(
          hintText: 'Как тебя зовут?', counter: Offstage()),
      controller: _name,
      autocorrect: false,
      enableSuggestions: false,
    );
  }

  Widget passwordField({required String hintText}) {
    return TextFormField(
      cursorColor: const Color.fromARGB(255, 26, 25, 25),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Пароль - нужная штука';
        }
        return null;
      },
      decoration:
          InputDecoration(hintText: hintText, counter: const Offstage()),
      obscureText: true,
      obscuringCharacter: '*',
      maxLength: 10,
      controller: _password,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
      ],
    );
  }
}
