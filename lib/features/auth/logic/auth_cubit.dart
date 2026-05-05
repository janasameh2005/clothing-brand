import 'package:clothes/features/auth/data/models/user_model.dart';
import 'package:clothes/features/auth/data/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    );
    
    result.fold(
      (error) => emit(AuthFailure(error)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.login(
      email: email,
      password: password,
    );
    
    result.fold(
      (error) => emit(AuthFailure(error)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
