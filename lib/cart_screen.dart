import 'package:clothing_brand/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:clothing_brand/cart_items.dart'; // قائمة globalCartItems
import 'package:clothing_brand/order_details_screen.dart';
import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double calculateSubTotal() {
    double total = 0;
    for (var item in globalCartItems) {
      String priceString = item['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
      double price = double.tryParse(priceString) ?? 0;
      int quantity = item['quantity'] ?? 1;
      total += (price * quantity);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = calculateSubTotal();
    double shipping = 100; 
    double finalTotal = globalCartItems.isEmpty ? 0 : subTotal + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF0),
      body: globalCartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "My Cart",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: globalCartItems.length,
                    itemBuilder: (context, index) {
                      final itemData = globalCartItems[index];
                      String currentPriceStr = itemData['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
                      double currentPrice = double.tryParse(currentPriceStr) ?? 0;
                    
                      String oPrice = itemData['old_price']?.toString() ?? 
                                     (currentPrice * 1.25).toStringAsFixed(0);
                      final itemModel = CartItemModel(
                        id: index,
                        name: itemData['title'] ?? "No Name",
                        image: itemData['image'] ?? "",
                        price: currentPrice,
                        quantity: itemData['quantity'] ?? 1,
                        priceDisplay: "${itemData['price']}",
                        oldPrice: oPrice, 
                      );
                      return CartItemWidget(
                        item: itemModel,
                        onDelete: () {
                          setState(() {
                            globalCartItems.removeAt(index);
                          });
                        },
                        onQuantityChanged: (newQty) {
                          setState(() {
                            globalCartItems[index]['quantity'] = newQty;
                          });
                        }, cartCubit: context.read<CartCubit>(),
                      );
                    },
                  ),
                ),
                _buildPromoCodeField(),
                _buildBottomSummary(context, subTotal, finalTotal),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Text("Your cart is empty!", style: TextStyle(fontSize: 18, color: Colors.grey)),
    );
  }

  Widget _buildPromoCodeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Promo Code",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0404),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, double subTotal, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sub Total", style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text("${subTotal.toStringAsFixed(0)} EGP", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("${total.toStringAsFixed(0)} EGP", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A0404))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                List<CartItemModel> itemsForOrder = globalCartItems.map((item) {
                   String op = item['old_price']?.toString() ?? "1500";
                   return CartItemModel(
                    id: 0,
                    name: item['title'],
                    image: item['image'],
                    price: double.tryParse(item['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
                    quantity: item['quantity'],
                    priceDisplay: "${item['price']} EGP",
                    oldPrice: op,
                  );
                }).toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(
                      cartItems: itemsForOrder,
                      totalPrice: "${total.toStringAsFixed(0)} EGP",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0404),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Buy Now", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final CartCubit cartCubit;
  final VoidCallback onDelete;
  final Function(int) onQuantityChanged;

  const CartItemWidget({
    required this.item,
    required this.cartCubit,
    required this.onDelete,
    required this.onQuantityChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      item.image,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      headers: const {"ngrok-skip-browser-warning": "true"},
                      errorBuilder: (_, __, ___) => Container(
                        width: 130,
                        height: 130,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {
    if (item.quantity > 1) {
      onQuantityChanged(item.quantity - 1);
    }
  },
  child: const Padding(
    padding: EdgeInsets.all(10.0),
    child: Icon(Icons.remove, size: 18),
  ),
),

Text(
  "${item.quantity}",
  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {
      onQuantityChanged(item.quantity + 1);
  },
  child: const Padding(
    padding: EdgeInsets.all(10.0),
    child: Icon(Icons.add, size: 18, color: Color(0xFF4A0404)),
  ),
),
      ],
    ),
  ),
),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Color(0xFF4A0404)),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                Row(
                  children: List.generate(5, (index) => 
                    const Icon(Icons.star, color: Color(0xFFFFB800), size: 18)
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${item.oldPrice} EGP",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Color(0xFF4A0404),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.priceDisplay}\nEGP",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        _buildColorDot(const Color(0xFFA68D85)),
                        _buildColorDot(const Color(0xFF4A0404)),
                        _buildColorDot(const Color(0xFF1B4332)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}