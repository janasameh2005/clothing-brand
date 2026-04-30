import 'package:flutter/material.dart';
import 'product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  final List<Map<String, dynamic>> wishItems;
  final Function(Map<String, dynamic>) onToggle;

   WishlistScreen({super.key, required this.wishItems, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("Wishlist", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif')),
        ),
        Expanded(
          child: wishItems.isEmpty
              ? const Center(child: Text("Your wishlist is empty"))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: wishItems.length,
            itemBuilder: (context, index) {
              final item = wishItems[index];
              return _buildWishlistItem(context, item, screenHeight, screenWidth);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistItem(BuildContext context, Map<String, dynamic> item, double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.025),
      padding: const EdgeInsets.all(12),
      height: screenHeight * 0.22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(item['image'], width: screenWidth * 0.32, height: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    GestureDetector(
                      onTap: () => onToggle(item),
                      child: const Icon(Icons.delete_outline, color: Color(0xFF4D0C0C), size: 22),
                    ),
                  ],
                ),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < (item['rating'] ?? 5) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item['oldPrice'] != null)
                      Text(item['oldPrice'], style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                    Text(item['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4D0C0C))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              title: item['title'],
                              price: item['price'],
                              imagePath: item['image'],
                              isFavorite: true,
                              onFavoriteTap: () => onToggle(item),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 16),
                            SizedBox(width: 6),
                            Text("Shop", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onToggle(item),
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 4, right: 4),
                        child: Icon(Icons.favorite, color: Colors.red, size: 26),
                      ),
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
}