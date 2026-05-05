import 'package:clothes/core/networking/api_service.dart';
import 'package:clothes/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepo {
  final ApiService _apiService;

  AuthRepo(this._apiService);

  Future<Either<String, UserModel>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/signup/',
        data: {
          'username': email,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/login/',
        data: {'email': email, 'password': password},
      );

      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
