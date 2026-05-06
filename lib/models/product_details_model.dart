import 'package:flutter/material.dart';

class ProductDetailsResponse {
  final ProductDetails product;
  final List<RecommendationItem> recommendations;
  ProductDetailsResponse({required this.product, required this.recommendations});
}

class ProductDetails {
  final int id;
  final String name;
  final String priceDisplay;
  final String imageUrl;
  final String? discountLabel;
  final String description;
  final double rating;
  final List<ColorItem> colors;
  final List<SizeItem> availableSizes;

  ProductDetails({
    required this.id, required this.name, required this.priceDisplay,
    required this.imageUrl, this.discountLabel, required this.description,
    required this.rating, required this.colors, required this.availableSizes,
  });
}

class ColorItem { final String hexCode; ColorItem({required this.hexCode}); }
class SizeItem { final String name; SizeItem({required this.name}); }
class RecommendationItem {
  final int id; final String name; final String priceDisplay; final String imageUrl;
  RecommendationItem({required this.id, required this.name, required this.priceDisplay, required this.imageUrl});
}

// هنا الحل: الميثود بقت تاخد Map مش String
ProductDetailsResponse productDetailsResponseFromJson(Map<String, dynamic> jsonData) {
  final prod = jsonData['product'];
  return ProductDetailsResponse(
    product: ProductDetails(
      id: prod['id'],
      name: prod['name'],
      priceDisplay: prod['price_display'],
      imageUrl: prod['image_url'],
      description: prod['description'],
      rating: (prod['rating'] as num?)?.toDouble() ?? 4.5,
      discountLabel: prod['discount_label'],
      colors: (prod['colors'] as List).map((c) => ColorItem(hexCode: c['hex_code'])).toList(),
      availableSizes: (prod['sizes'] as List).map((s) => SizeItem(name: s['name'])).toList(),
    ),
    recommendations: jsonData['recommendations'] != null
        ? (jsonData['recommendations'] as List).map((r) => RecommendationItem(
      id: r['id'], name: r['name'], priceDisplay: r['price_display'], imageUrl: r['image_url'],
    )).toList() : [],
  );
}