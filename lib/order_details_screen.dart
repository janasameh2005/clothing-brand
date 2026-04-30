import 'package:clothing_brand/check_out_screen.dart';
import 'package:flutter/material.dart';
import 'apptheme.dart';
import 'custom_appbar.dart';

class OrderDetailsScreen extends StatelessWidget {
  final List<dynamic> cartItems; 
  final String totalPrice;

  const OrderDetailsScreen({
    super.key, 
    required this.cartItems, 
    required this.totalPrice
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.white,
      appBar: CustomAppBar(showArrowBack: true, languageNotification: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Order Details",
                      style: Apptheme.textTheme.displaySmall?.copyWith(
                        fontFamily: 'Serif', fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (cartItems.isEmpty)
                    const Center(child: Text("Your cart is empty"))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return OrderItemCard(
                          name: item['product_name'] ?? "Product",
                          price: "${item['price']} EGP",
                          oldPrice: "${item['old_price'] ?? ''} EGP",
                          color: item['color'] ?? "N/A",
                          size: item['size'] ?? "N/A",
                          rating: "4/5", 
                          imagePath: item['image_url'] ?? "", 
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomSummary(context, "Payment", totalPrice, () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(total: totalPrice, subTotal: totalPrice)
              )
            );
          }),
        ],
      ),
    );
  }
  Widget _buildBottomSummary(BuildContext context, String buttonText, String total, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Color(0xFFE5D0AC), thickness: 1.2),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total", style: Apptheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(total, style: Apptheme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Apptheme.accentDark)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.accentDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
class OrderItemCard extends StatelessWidget {
  final String name, price, oldPrice, color, size, rating, imagePath;

  const OrderItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.color,
    required this.size,
    required this.rating,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    oldPrice,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color:Apptheme.accentDark,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _richTextItem("Product Name: ", name),
                _richTextItem("Price: ", price),
                _richTextItem("Color: ", color),
                _richTextItem("Size: ", size),
                _richTextItem("Rating: ", rating),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _richTextItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Apptheme.accentDark,
            fontSize: 14,
            fontFamily: 'Roboto',
          ),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}