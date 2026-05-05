import 'package:clothes/core/networking/api_service.dart';
import 'package:clothes/features/auth/data/repos/auth_repo.dart';
import 'package:clothes/features/auth/logic/auth_cubit.dart';

// Simple Service Locator pattern
class ServiceLocator {
  static final ApiService apiService = ApiService();
  static final AuthRepo authRepo = AuthRepo(apiService);
  
  static AuthCubit get authCubit => AuthCubit(authRepo);
}
