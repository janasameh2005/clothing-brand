// cart_cubit.dart
import 'package:clothing_brand/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class CartState {}
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState { 
  final CartResponse cartData; 
  CartLoaded(this.cartData); 
}
class CartError extends CartState { 
  final String message; 
  CartError(this.message); 
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  Future<void> addToCart(int productId) async {
    emit(CartLoading());
    try {
      final url = Uri.parse('https://88myhsysdelr.shares.zrok.io/api/cart/add/');
      
      final response = await http.post(
        url,
        headers: {
          "ngrok-skip-browser-warning": "any-value",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "product_id": productId,
          "quantity": 1,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CartLoaded(CartResponse.fromJson(json.decode(response.body))));
      } else {
        emit(CartError("Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
    Future<void> fetchCart() async {
    emit(CartLoading());
    try {
      final url = Uri.parse('https://88myhsysdelr.shares.zrok.io/api/cart/');
      
      final response = await http.get(
        url,
        headers: {
          "ngrok-skip-browser-warning": "any-value",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CartLoaded(CartResponse.fromJson(json.decode(response.body))));
      } else {
        emit(CartError("Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
 Future<void> removeFromCart(int productId) async {
  emit(CartLoading());
  try {
    final url = Uri.parse('https://88myhsysdelr.shares.zrok.io/api/cart/');

    final response = await http.delete(
      url,
      headers: {
        "ngrok-skip-browser-warning": "any-value", 
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "product_id": productId,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      final responseData = json.decode(response.body);
      emit(CartLoaded(CartResponse.fromJson(responseData)));
    } else {
      emit(CartError("Server Error: ${response.statusCode}"));
    }
  } catch (e) {
    emit(CartError("Connection Error: ${e.toString()}"));
  }
}
void updateQuantity(int itemId, int newQuantity) {
  if (state is CartLoaded) {
    final currentCartData = (state as CartLoaded).cartData;
    for (var item in currentCartData.items) {
      if (item.id == itemId) {
        item.quantity = newQuantity;
        break;
      }
    }
    emit(CartLoading()); 
    emit(CartLoaded(currentCartData));
  }
}
}