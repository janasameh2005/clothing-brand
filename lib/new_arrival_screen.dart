import 'package:flutter/material.dart';
import 'item_card.dart';

class NewArrivalsScreen extends StatelessWidget {
  const NewArrivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        "title": "Summer Dress",
        "price": "1400 EGP",
        "image": "assets/images/dress3 1.png",
        "colors": [Colors.pink[50]!, Colors.blue[900]!, Colors.red[900]!, Colors.green[900]!]
      },
      {
        "title": "Linen Suit",
        "price": "2000 EGP",
        "image": "assets/images/suit 1.png",
        "colors": [Colors.grey[300]!, Colors.green[900]!, Colors.blue[900]!, Colors.black]
      },
      {
        "title": "Pants",
        "price": "700 EGP",
        "image": "assets/images/white cotton shirt 1.png",
        "colors": [Colors.white, Colors.blue[900]!, Colors.red[900]!, Colors.green[900]!]
      },
      {
        "title": "Black Vest",
        "price": "750 EGP",
        "image": "assets/images/suit 1.png",
        "colors": [Colors.teal[200]!, Colors.green[900]!, Colors.blue[900]!, Colors.black]
      },
      {
        "title": "Floral Skirt",
        "price": "900 EGP",
        "image": "assets/images/dress3 1.png",
        "colors": [Colors.pink[50]!, Colors.blue[900]!, Colors.red[900]!, Colors.green[900]!]
      },
      {
        "title": "Red Blouse",
        "price": "650 EGP",
        "image": "assets/images/suit 1.png",
        "colors": [Colors.red, Colors.teal[200]!, Colors.blue[900]!, Colors.black]
      },
    ];

    return SizedBox.expand(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "New Arrivals",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
                color: Colors.black,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.52,
                ),
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ItemCard(
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