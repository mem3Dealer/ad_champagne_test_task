import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'auth_state.g.dart';

@HiveType(typeId: 1)
class AuthState extends Equatable with HiveObjectMixin {
  @HiveField(0)
  String email;

  @HiveField(1)
  String password;
  AuthState({
    required this.email,
    required this.password,
  });

  AuthState copyWith({
    String? email,
    String? password,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source));

  @override
  String toString() => 'AuthState(email: $email, password: $password)';

  @override
  List<Object> get props => [email, password];
}
