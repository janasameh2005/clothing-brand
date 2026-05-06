import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';

// States
abstract class NewArrivalsState {}
class NewArrivalsInitial extends NewArrivalsState {}
class NewArrivalsLoading extends NewArrivalsState {}
class NewArrivalsSuccess extends NewArrivalsState {
  final List<ProductModel> products;
  final String title; 
  NewArrivalsSuccess(this.products, this.title);
}
class NewArrivalsError extends NewArrivalsState {
  final String message;
  NewArrivalsError(this.message);
}

// Cubit
class NewArrivalsCubit extends Cubit<NewArrivalsState> {
  NewArrivalsCubit() : super(NewArrivalsInitial());

  Future<void> fetchNewArrivals() async {
    emit(NewArrivalsLoading());
    try {
final response = await http.get(
  Uri.parse('https://10cxyvxk6z8u.shares.zrok.io/api/products/new-arrivals/'),
  headers: {
    "Accept": "application/json",
    "ngrok-skip-browser-warning": "true",
    "zrok-skip-browser-warning": "true", 
  },
);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> itemsJson = data['items'] ?? [];
        String pageTitle = data['header_bar']['title'] ?? "New Arrivals";

        List<ProductModel> products = itemsJson
            .map((item) => ProductModel.fromJson(item))
            .toList();

        emit(NewArrivalsSuccess(products, pageTitle));
      } else {
        emit(NewArrivalsError("Status Code: ${response.statusCode}"));
      }
    } catch (e) {
      emit(NewArrivalsError("Error: ${e.toString()}"));
    }
  }
}