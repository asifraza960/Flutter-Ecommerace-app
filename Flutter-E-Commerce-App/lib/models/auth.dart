import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final int id;
  final String email;
  final String username;
  final String token;

  const AuthUser({
    required this.id,
    required this.email,
    required this.username,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'username': username, 'token': token};
  }

  @override
  List<Object?> get props => [id, email, username, token];
}

class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String firstname;
  final String lastname;

  const RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'name': {'firstname': firstname, 'lastname': lastname},
    };
  }
}
