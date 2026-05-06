import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'item_card.dart';

class ProductsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // جوه الـ build function في ملف products_screen.dart
    final List<Map<String, dynamic>> allProducts = [
      // Shirts -> catId: 1
      {"id": 11, "catId": 1, "title": "Puff Sleeve Shirt", "price": "1500 EGP", "image": "assets/images/white cotton shirt 1.png", "colors": [Colors.white]},

      // Pants -> catId: 2
      {"id": 5, "catId": 2, "title": "Casual Pants", "price": "699 EGP", "image": "assets/images/suit 1.png", "colors": [Colors.grey]},

      // Dresses -> catId: 3
      {"id": 1, "catId": 3, "title": "Summer Dress", "price": "1400 EGP", "image": "assets/images/dress3 1.png", "colors": [Colors.pink]},
      {"id": 10, "catId": 3, "title": "Elegant Dress", "price": "2000 EGP", "image": "assets/images/dress3 1.png", "colors": [Colors.black]},

      // Suits -> catId: 4
      {"id": 2, "catId": 4, "title": "Linen Suit", "price": "2000 EGP", "image": "assets/images/suit 1.png", "colors": [Colors.brown]},

      // Blouses -> catId: 5 (عشان تحل مشكلة الصورة الأولى)
      {"id": 8, "catId": 5, "title": "Red Blouse", "price": "650 EGP", "image": "assets/images/dress3 1.png", "colors": [Colors.red]},

      // Hoodies -> catId: 6
      {"id": 9, "catId": 6, "title": "Cool Hoodie", "price": "1000 EGP", "image": "assets/images/suit 1.png", "colors": [Colors.blue]},

      // Vests -> catId: 7
      {"id": 6, "catId": 7, "title": "Black Vest", "price": "750 EGP", "image": "assets/images/suit 1.png", "colors": [Colors.black]},

      // Skirts -> catId: 8
      {"id": 7, "catId": 8, "title": "Floral Skirt", "price": "900 EGP", "image": "assets/images/dress3 1.png", "colors": [Colors.white]},

      // Jackets -> catId: 9 (عشان تحل مشكلة الصورة الثالثة)
      {"id": 4, "catId": 9, "title": "Cropped Trench", "price": "1500 EGP", "image": "assets/images/suit 1.png", "colors": [Colors.white]},
      {"id": 3, "catId": 9, "title": "Zara Blazer", "price": "1120 EGP", "image": "assets/images/suit 1.png", "colors": [Colors.black]},
    ];

    final filteredProducts = allProducts.where((p) => p['catId'] == categoryId).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        showArrowBack: true,
        languageNotification: true,
        onBackTap: () => Navigator.pop(context), // ضفتلك دي عشان زرار الرجوع يشتغل
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              categoryName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif'),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredProducts.isEmpty
                  ? Center(child: Text("No products found in $categoryName yet!"))
                  : GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.52,
                ),
                itemBuilder: (context, index) {
                  final p = filteredProducts[index];
                  // الإصلاح هنا: نبعت الـ p['id']
                  return ItemCard(
                    id: p['id'], // السطر ده اللي هيشيل الـ Error
                    title: p['title'],
                    price: p['price'],
                    imagePath: p['image'],
                    colors: List<Color>.from(p['colors']),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}