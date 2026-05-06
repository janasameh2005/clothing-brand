import 'package:flutter_bloc/flutter_bloc.dart';
import '../api_service/api_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiService apiService = ApiService();

  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading()); // ابدأ التحميل
    try {
      final data = await apiService.fetchProfileData();
      if (data != null) {
        emit(ProfileSuccess(data)); // نجاح
      } else {
        emit(ProfileError("لم يتم العثور على بيانات")); // فشل
      }
    } catch (e) {
      emit(ProfileError("خطأ في الاتصال: $e")); // خطأ تقني
    }
  }
}