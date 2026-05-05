import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';
abstract class NewArrivalsState {}

class NewArrivalsInitial extends NewArrivalsState {}
class NewArrivalsLoading extends NewArrivalsState {}
class NewArrivalsSuccess extends NewArrivalsState {
  final List<ProductModel> products;
  NewArrivalsSuccess(this.products);
}
class NewArrivalsError extends NewArrivalsState {
  final String errorMessage;
  NewArrivalsError(this.errorMessage);
}
class NewArrivalsCubit extends Cubit<NewArrivalsState> {
  NewArrivalsCubit() : super(NewArrivalsInitial());

  Future<void> getNewArrivals() async {
    emit(NewArrivalsLoading());
    try {
      final response = await http.post(
        Uri.parse('https://88myhsysdelr.shares.zrok.io/api/products/new-arrivals/'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> productsJson = data['products'] ?? data['results'] ?? [];
        
        List<ProductModel> products = productsJson
            .map((item) => ProductModel.fromJson(item))
            .toList();
            
        emit(NewArrivalsSuccess(products));
      } else {
        emit(NewArrivalsError("Server Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(NewArrivalsError("Connection Error: ${e.toString()}"));
    }
  }
}