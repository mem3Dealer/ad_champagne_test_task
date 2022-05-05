import 'package:ad_champagne_test_task/bloc/auth_bloc.dart';
import 'package:ad_champagne_test_task/bloc/auth_state.dart';
import 'package:ad_champagne_test_task/theme.dart';
import 'package:ad_champagne_test_task/user%20model/model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/loginPage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive
    ..registerAdapter(UserAdapter())
    ..registerAdapter(AuthStateAdapter());
  await Hive.openBox<User>('users');
  await Hive.openBox<AuthState>('authStates');
  GetIt.instance.registerSingleton<AuthBloc>(
      AuthBloc(AuthState(email: '', password: '')));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdChampagne test task',
      theme: ChampagneTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
