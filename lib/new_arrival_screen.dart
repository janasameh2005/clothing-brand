import 'package:clothing_brand/apptheme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item_card.dart';

class NewArrivalsScreen extends StatefulWidget {
  const NewArrivalsScreen({super.key});

  @override
  State<NewArrivalsScreen> createState() => _NewArrivalsScreenState();
}

class _NewArrivalsScreenState extends State<NewArrivalsScreen> {
  Future<List<dynamic>>? _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://uncurled-resolute-ducky.ngrok-free.dev/products/new-arrivals'),
        headers: {
          "ngrok-skip-browser-warning": "true",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
  void _retry() {
    setState(() {
      _productsFuture = fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "New Arrivals",
                style: Apptheme.textTheme.displaySmall?.copyWith(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (_productsFuture == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Apptheme.accentDark),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 40),
                          const SizedBox(height: 10),
                          Text("Something went wrong", style: Apptheme.textTheme.bodyMedium),
                          TextButton(
                            onPressed: _retry,
                            child: const Text("Try Again"),
                          )
                        ],
                      ),
                    );
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(child: Text("No products found."));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.55,
                      ),
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return ItemCard(
                          title: p['title'] ?? 'New Item',
                          price: p['price']?.toString() ?? '0 EGP',
                          imagePath: p['image'] ?? '',
                          colors: const [Colors.black, Colors.grey],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}