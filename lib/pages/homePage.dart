import 'package:ad_champagne_test_task/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../bloc/auth_bloc.dart';
import '../user model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authBloc = GetIt.I.get<AuthBloc>();
  Box userBox = Hive.box<User>('users');
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    String key = authBloc.state.email;
    User user = userBox.get(key);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Oh, hi, ${user.name}'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Text(
                  'Привет!\n Если ты забыл, то тебя зовут ${user.name}, а мыло твое - ${user.email}',
                  textAlign: TextAlign.center,
                  style: _theme.textTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      authBloc.add(AuthLogOut(onSuccsess: () {
                        Navigator.of(context).pop();
                      }));
                    },
                    child: const Text('Выйтить')),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffE14D43))),
                  onPressed: () => authBloc
                      .add(AuthDeleteUser(user: user, context: context)),
                  child: const Text('Удалить свой аккаунт и выйтить'))
            ],
          ),
        ),
      ),
    );
  }
}
