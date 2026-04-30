import 'dart:convert';
import 'package:http/http.dart' as http;

class CartResponse {
  final List<CartItemModel> items;
  final Map<String, dynamic> summary;
  final Map<String, dynamic> headerBar;

  CartResponse({
    required this.items,
    required this.summary,
    required this.headerBar,
  });

  static Future<void> addToCart(int productId, int quantity) async {
    final url = Uri.parse('https://uncurled-resolute-ducky.ngrok-free.dev/api/cart/add/');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({
          "product_id": productId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Success: Product added to cart!");
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      summary: json['summary'] ?? {},
      headerBar: json['header_bar'] ?? {},
    );
  }
}

class CartItemModel {
  final String name;
  final String image;
  final double price;
  final int quantity;

  CartItemModel({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      name: json['name'] ?? 'No Name',
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}