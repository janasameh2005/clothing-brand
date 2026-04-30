import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/custom_appbar.dart';
import 'package:clothing_brand/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Future<CartResponse> fetchCartData() async {
    final url = Uri.parse('https://uncurled-resolute-ducky.ngrok-free.dev/api/cart/');

    try {
      final response = await http.get(
        url,
        headers: {
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        return CartResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Server Error. Check your ngrok connection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.white,
      body: FutureBuilder<CartResponse>(
        future: fetchCartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Apptheme.accentDark));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Error: ${snapshot.error}", textAlign: TextAlign.center),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text("Your cart is currently empty. Start shopping!"));
          }

          final cartData = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        cartData.headerBar['title'] ?? "My Cart",
                        style: Apptheme.textTheme.displaySmall?.copyWith(fontFamily: 'Serif'),
                      ),
                      const SizedBox(height: 20),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartData.items.length,
                        itemBuilder: (context, index) {
                          final item = cartData.items[index];
                          return CartItemWidget(
                            name: item.name,
                            price: "${item.price} EGP",
                            imagePath: item.image,
                            quantity: item.quantity.toString(),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                      _buildPromoCodeField(),
                    ],
                  ),
                ),
              ),
              _buildBottomSummary(
                context,
                cartData.summary['button_text'] ?? "Buy Now",
                cartData.summary['sub_total'] ?? "0 EGP",
                cartData.summary['total'] ?? "0 EGP",
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromoCodeField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Promo Code",
        filled: true,
        fillColor: const Color(0xFF8F8B7B).withOpacity(0.1),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Apptheme.accentDark),
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, String btnText, String subTotal, String total) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Apptheme.greyText.withOpacity(0.3))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sub Total", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(subTotal, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Apptheme.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(total, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Apptheme.accentDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))
                    ),
                    child: Text(btnText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final String name, price, imagePath, quantity;
  const CartItemWidget({required this.name, required this.price, required this.imagePath, required this.quantity, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Apptheme.greyText.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imagePath,
              width: 90, height: 90, fit: BoxFit.cover,
              headers: const {"ngrok-skip-browser-warning": "true"},
              errorBuilder: (_, __, ___) => Container(
                  width: 90, height: 90,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported)
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(price, style: const TextStyle(color: Apptheme.accentDark, fontWeight: FontWeight.bold)),
                Text("Qty: $quantity", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          const Icon(Icons.delete_outline, color: Apptheme.accentDark),
        ],
      ),
    );
  }
}