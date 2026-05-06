import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String name;
  final String priceDisplay;
  final String imageUrl;
  final List<Color> colors;

  ProductModel({
    required this.id,
    required this.name,
    required this.priceDisplay,
    required this.imageUrl,
    required this.colors,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var colorList = (json['colors'] as List).map((c) {
      String hex = c['hex_code'].replaceAll('#', '');
      return Color(int.parse("FF$hex", radix: 16));
    }).toList();

    return ProductModel(
      id: json['id'],
      name: json['name'],
      priceDisplay: json['price_display'],
      imageUrl: json['image_url'],
      colors: colorList,
    );
  }
}