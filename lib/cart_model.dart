class CartItemModel {
  final int id;
  final String name;
  final String image;
  final String priceDisplay; 
  final double price;
  int quantity;
  final String? oldPrice;

  CartItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.priceDisplay,
    required this.price,
    required this.quantity,
    this.oldPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product']; 
    
    return CartItemModel(
      id: productJson['id'],
      name: productJson['name'] ?? 'No Name',
      image: productJson['image_url'] ?? '',
      priceDisplay: productJson['price_display'] ?? '',
      price: double.tryParse(productJson['price'].toString()) ?? 0.0,
      quantity: json['quantity'] ?? 1,
      oldPrice: productJson['old_price'].toString(),
    );
  }
}class CartResponse {
  final List<CartItemModel> items;
  final Map<String, dynamic> summary;
  final Map<String, dynamic> headerBar;

  CartResponse({
    required this.items,
    required this.summary,
    required this.headerBar,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items: (json['items'] as List? ?? [])
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      summary: json['summary'] ?? {},
      headerBar: json['header_bar'] ?? {},
    );
  }
}