import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/auth.dart';
import '../services/api_service.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService;
  static const String _userKey = 'auth_user';

  AuthCubit(this._apiService) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        final user = AuthUser.fromJson(userMap);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      final request = LoginRequest(username: username, password: password);
      final user = await _apiService.login(request);

      // Save user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    emit(AuthLoading());
    try {
      final request = RegisterRequest(
        email: email,
        username: username,
        password: password,
        firstname: firstname,
        lastname: lastname,
      );
      final user = await _apiService.register(request);

      // Save user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    emit(AuthUnauthenticated());
  }

  int? get currentUserId {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user.id;
    }
    return null;
  }

  bool get isAuthenticated => state is AuthAuthenticated;
}
