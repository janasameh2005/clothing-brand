import 'package:clothing_brand/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/cart_model.dart';
import 'package:clothing_brand/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..fetchCart(),
      child: Scaffold(
        backgroundColor: Apptheme.white,
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Apptheme.accentDark),
              );
            } else if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.message}"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<CartCubit>().fetchCart(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            } else if (state is CartLoaded) {
              final cartData = state.cartData;

              if (cartData.items.isEmpty) {
                return const Center(
                  child: Text("Your cart is currently empty. Start shopping!"),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Text(
                            cartData.headerBar['title'] ?? "My Cart",
                            style: Apptheme.textTheme.displaySmall
                                ?.copyWith(fontFamily: 'Serif', fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartData.items.length,
                            itemBuilder: (ctx, index) {
                              final item = cartData.items[index];
                              return CartItemWidget(
                                item: item, 
                                cartCubit: context.read<CartCubit>()
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          _buildPromoCodeField(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomSummary(context, cartData),
                ],
              );
            }
            return const SizedBox();
          },
        ),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.accentDark),
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, dynamic cartData) {
    String btnText = cartData.summary['button_text'] ?? "Buy Now";
    String subTotal = cartData.summary['sub_total'] ?? "0 EGP";
    String total = cartData.summary['total'] ?? "0 EGP";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Apptheme.greyText.withOpacity(0.3))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sub Total",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(subTotal,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    const Text("Total",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(total,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          cartItems: cartData.items,
                          totalPrice: total,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Apptheme.accentDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24))),
                    child: Text(btnText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
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
  final CartItemModel item;
  final CartCubit cartCubit;

  const CartItemWidget({
    required this.item,
    required this.cartCubit,
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
          // القسم الأيسر: الصورة والتحكم في الكمية
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
                          // زر النقصان
// زر النقصان
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {
    if (item.quantity > 1) {
      cartCubit.updateQuantity(item.id, item.quantity - 1); 
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
      cartCubit.updateQuantity(item.id, item.quantity + 1);
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
          // القسم الأيمن: البيانات
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
                      onPressed: () => cartCubit.removeFromCart(item.id),
                    ),
                  ],
                ),
                // تقييم النجوم
                Row(
                  children: List.generate(5, (index) => 
                    const Icon(Icons.star, color: Color(0xFFFFB800), size: 18)
                  ),
                ),
                const SizedBox(height: 12),
                // السعر المشطوب
                const Text(
                  "1500 EGP",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Color(0xFF4A0404),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // السعر الحالي ودوائر الألوان
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