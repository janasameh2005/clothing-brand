import 'package:clothing_brand/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';
import 'item_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // متغيرات عشان نحدد اللون والمقاس المختار (زي الصورة)
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;

  Color _parseHexColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(showArrowBack: true, languageNotification: true),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4D0C0C)));
          } else if (state is ProductDetailsSuccess) {
            final product = state.data.product;
            final recommendations = state.data.recommendations;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المنتج
                  Stack(
                    children: [
                      Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        height: 450, // زودت الطول شوية زي الصورة
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 20, right: 20,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.favorite_border, color: Colors.black, size: 28),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الاسم والتقييم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text("${product.rating}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // السعر
                        Text(product.priceDisplay, style: const TextStyle(fontSize: 22, color: Color(0xFF4D0C0C), fontWeight: FontWeight.bold)),

                        const SizedBox(height: 25),
                        // اختيار اللون (معدل ليكون زي الصورة بالظبط)
                        const Text("Select Color", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(product.colors.length, (index) {
                            bool isSelected = selectedColorIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => selectedColorIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: _parseHexColor(product.colors[index].hexCode),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 25),
                        // اختيار المقاس
                        const Text("Select Size", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(product.availableSizes.length, (index) {
                            bool isSelected = selectedSizeIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSizeIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                    product.availableSizes[index].name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 35),
                        // زر Add to Cart (Rounded أكثر)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B0E0E), // اللون النبيتي الغامق
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: () {},
                            child: const Text("Add to cart", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // زر Buy it now
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: () {},
                            child: const Text("Buy it now", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 30),
                        // الوصف
                        const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                            product.description,
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.5)
                        ),

                        const SizedBox(height: 40),
                        // You also may like
                        const Text("You also may like", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 280,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 15),
                            itemBuilder: (context, index) {
                              final item = recommendations[index];
                              return SizedBox(
                                width: 160,
                                child: ItemCard(
                                  id: item.id,
                                  title: item.name,
                                  price: item.priceDisplay,
                                  imagePath: item.imageUrl,
                                  colors: const [Colors.pink, Colors.red],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductDetailsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}