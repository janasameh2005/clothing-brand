import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_details_state.dart';
import '../api_service/product_mock_data.dart';
import '../models/product_details_model.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<void> loadProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final localJson = ProductMockData.getFallbackData(productId);
      // بنستخدم الـ function اللي في الموديل عشان الكود هنا يبقى نظيف
      final response = productDetailsResponseFromJson(localJson);

      emit(ProductDetailsSuccess(response));
    } catch (e) {
      emit(ProductDetailsError("Error: ${e.toString()}"));
    }
  }
}