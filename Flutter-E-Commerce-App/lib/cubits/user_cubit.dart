import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import '../services/api_service.dart';

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class UserCubit extends Cubit<UserState> {
  final ApiService _apiService;

  UserCubit(this._apiService) : super(UserInitial());

  Future<void> loadUser(int userId) async {
    emit(UserLoading());
    try {
      final user = await _apiService.getUserById(userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> refreshUser(int userId) async {
    await loadUser(userId);
  }
}
