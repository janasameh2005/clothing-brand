import 'package:clothing_brand/cart_items.dart';
import 'package:clothing_brand/check_out_screen.dart';
import 'package:clothing_brand/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'item_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String title;
  final String price;
  final String imagePath;
  final String? oldPrice;
  final String? discount;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const ProductDetailsScreen({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.oldPrice,
    this.discount,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'M';
  late bool isFavoriteLocal;
  bool isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    isFavoriteLocal = widget.isFavorite;
  }
  Widget _buildProductImage(String path, double height) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 50)),
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 50)),
      );
    }
  }
void addToCartLocally() {
  setState(() {
    int existingIndex = globalCartItems.indexWhere((item) => 
      item['title'] == widget.title && item['size'] == selectedSize
    );

    if (existingIndex != -1) {
      globalCartItems[existingIndex]['quantity'] = 
          (globalCartItems[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      globalCartItems.add({
        'title': widget.title,
        'price': widget.price,
        'image': widget.imagePath,
        'size': selectedSize,
        'quantity': 1,
      });
    }
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("${widget.title} added to cart!")),
  );
}

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showArrowBack: true,
        languageNotification: true,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.45,
                  color: const Color(0xFFF9F9F9),
                  child: _buildProductImage(widget.imagePath, screenHeight * 0.45),
                ),
                if (widget.discount != null)
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFF4D0C0C), shape: BoxShape.circle),
                      child: Text("-${widget.discount}",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(widget.title,
                            style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => isFavoriteLocal = !isFavoriteLocal);
                          widget.onFavoriteTap();
                        },
                        child: Icon(isFavoriteLocal ? Icons.favorite : Icons.favorite_border,
                            color: isFavoriteLocal ? Colors.red : Colors.black, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(widget.price,
                          style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: const Color(0xFF4D0C0C))),
                      const SizedBox(width: 10),
                      if (widget.oldPrice != null)
                        Text(widget.oldPrice!,
                            style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                    ],
                  ),
                  
                  const SizedBox(height: 25),
                  const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: ['S', 'M', 'L', 'XL'].map((s) => GestureDetector(
                      onTap: () => setState(() => selectedSize = s),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedSize == s ? const Color(0xFF4D0C0C) : Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(s, style: TextStyle(color: selectedSize == s ? Colors.white : Colors.black)),
                      ),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isAddingToCart ? null : addToCartLocally,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D0C0C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isAddingToCart 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Add to cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Buy it now", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    "This high-quality piece is designed to provide both comfort and elegance. Perfect for various occasions, it features a modern cut and durable fabric.",
                    style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}