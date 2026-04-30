import 'package:flutter/material.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, String>> categories = [
      {"title": "Shirts", "image": "assets/images/white cotton shirt 1.png"},
      {"title": "Pants", "image": "assets/images/white cotton shirt 1.png"},
      {"title": "Dresses", "image": "assets/images/white cotton shirt 1.png"},
      {"title": "Suits", "image": "assets/images/suit 1.png"},
      {"title": "Blouse", "image": "assets/images/dress3 1.png"},
      {"title": "Hoodies", "image": "assets/images/suit 1.png"},
      {"title": "Vests", "image": "assets/images/suit 1.png"},
      {"title": "Shirts", "image": "assets/images/white cotton shirt 1.png"},
      {"title": "Jackets", "image": "assets/images/suit 1.png"},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
            child: const Text(
              "Collections",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: (screenWidth / 3) / (screenHeight * 0.22),
              ),
              itemBuilder: (context, index) {
                return _buildCategoryItem(
                    categories[index]['title']!,
                    categories[index]['image']!,
                    screenHeight
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String path, double screenHeight) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            path,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4D0C0C),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_right_alt,
              size: 16,
              color: Color(0xFF1E1E1E),
            ),
          ],
        ),
      ],
    );
  }
}