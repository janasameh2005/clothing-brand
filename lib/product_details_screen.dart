import 'package:clothing_brand/check_out_screen.dart';
import 'package:clothing_brand/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'item_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // --- دالة إضافة المنتج إلى السلة عبر الـ API ---
  Future<void> addToCart() async {
    setState(() {
      isAddingToCart = true;
    });

    final url = Uri.parse('https://88myhsysdelr.shares.zrok.io/api/cart/add/');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: json.encode({
          "name": widget.title,
          "price": widget.price.replaceAll(RegExp(r'[^0-9]'), ''),
          "image": widget.imagePath,
          "quantity": 1,
          "size": selectedSize,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" succesful addition!")),
        );
      } else {
        throw Exception('Failed to add: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("error adding to cart: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
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
                  child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                ),
                if (widget.discount != null)
                  Positioned(
                    bottom: screenHeight * 0.02,
                    right: screenWidth * 0.05,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: Color(0xFF4D0C0C), shape: BoxShape.circle),
                      child: Text("-${widget.discount}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
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
                      Text(widget.title,
                          style: TextStyle(
                              fontSize: screenWidth * 0.055,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif')),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavoriteLocal = !isFavoriteLocal;
                          });
                          widget.onFavoriteTap();
                        },
                        child: Icon(
                          isFavoriteLocal ? Icons.favorite : Icons.favorite_border,
                          color: isFavoriteLocal ? Colors.red : Colors.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(widget.price,
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      if (widget.oldPrice != null)
                        Text(widget.oldPrice!,
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey)),
                      const Spacer(),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star_half, color: Colors.amber, size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Select Color",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                      children: [
                    Colors.pink[50]!,
                    Colors.indigo[900]!,
                    Colors.red[900]!,
                    Colors.green[900]!
                  ]
                          .map((c) => Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                  backgroundColor: c,
                                  radius: screenWidth * 0.025)))
                          .toList()),
                  const SizedBox(height: 20),
                  const Text("Select Size",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                      children: ['S', 'M', 'L', 'XL']
                          .map((s) => GestureDetector(
                                onTap: () => setState(() => selectedSize = s),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: selectedSize == s
                                          ? const Color(0xFF4D0C0C)
                                          : Colors.white,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(s,
                                      style: TextStyle(
                                          color: selectedSize == s
                                              ? Colors.white
                                              : Colors.black)),
                                ),
                              ))
                          .toList()),
                  const SizedBox(height: 30),
                  
                  // --- زر Add to Cart المعدل ---
                  SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                          onPressed: isAddingToCart ? null : addToCart,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4D0C0C)),
                          child: isAddingToCart 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Add to cart",
                              style: TextStyle(color: Colors.white)))),
                  
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen())),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: const Text("Buy it now",
                              style: TextStyle(color: Colors.white)))),
                  const SizedBox(height: 25),
                  const Text("Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                      "High-waisted formal pants designed with soft front pleats...",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 40),
                  const Text(
                    "You also may like",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif'),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.35,
                      children: [
                        ItemCard(
                          title: "Floral Dress",
                          price: "1400 EGP",
                          imagePath: 'assets/images/dress3 1.png',
                          colors: [Colors.pink[50]!, Colors.red],
                        ),
                        ItemCard(
                          title: "Cropped Trench",
                          price: "750 EGP",
                          imagePath: 'assets/images/suit 1.png',
                          colors: [Colors.brown, Colors.black],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}