class ProductModel {
  final int id;
  final String title;
  final String price;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      price: json['price']?.toString() ?? '0',
      image: json['image'] ?? '',
    );
  }
}