import 'package:clothing_brand/cart_screen.dart';
import 'package:clothing_brand/profile_screen.dart';
import 'package:clothing_brand/settings.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item_card.dart';
import 'custom_appbar.dart';
import 'custom_bottom_navigation_bar.dart';
import 'new_arrival_screen.dart';
import 'collections_screen.dart';
import 'wishlist_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isSearching = false;
  String _searchQuery = "";

  final List<Map<String, dynamic>> _wishlistItems = [];

  // دالة جلب البيانات من الـ API مع تحديث الهيدرز وتنسيق الـ JSON الجديد
  Future<List<dynamic>> fetchNewArrivals() async {
    try {
      final response = await http.get(
        Uri.parse('https://10cxyvxk6z8u.shares.zrok.io/api/products/new-arrivals/'),
        headers: {
          "Accept": "application/json",
          "zrok-skip-browser-warning": "true", // لتخطي رسالة حماية zrok
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        // الوصول لمفتاح items حسب هيكل الـ JSON الذي أرسلتِه
        return data['items'] ?? [];
      } else {
        debugPrint("Server Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching Home New Arrivals: $e");
      return [];
    }
  }

  void _toggleWishlist(Map<String, dynamic> product) {
    setState(() {
      bool isExist = _wishlistItems.any((item) => 
        (item['id'] != null && item['id'] == product['id']) || 
        (item['title'] == product['title'] && item['title'] != null)
      );
      
      if (isExist) {
        _wishlistItems.removeWhere((item) => 
          (item['id'] != null && item['id'] == product['id']) || 
          (item['title'] == product['title'])
        );
      } else {
        _wishlistItems.add(product);
      }
    });
  }

  // القائمة الثابتة (Assets)
  final List<Map<String, dynamic>> _allProducts = [
    {
      "title": "Summer Dress",
      "price": "1400 EGP",
      "image": 'assets/images/dress3 1.png',
      "colors": [Colors.pink[50]!, Colors.blue[900]!, Colors.red[900]!]
    },
    {
      "title": "Linen Suit",
      "price": "2000 EGP",
      "image": 'assets/images/suit 1.png',
      "colors": [Colors.grey, Colors.green[900]!, Colors.black]
    },
    {
      "title": "Zara Blazer",
      "price": "1120 EGP",
      "oldPrice": "1600 EGP",
      "discount": "30%",
      "image": 'assets/images/dress3 1.png',
      "colors": [Colors.white, Colors.blue[900]!, Colors.black]
    },
    {
      "title": "Cropped Trench",
      "price": "750 EGP",
      "oldPrice": "1500 EGP",
      "discount": "50%",
      "image": 'assets/images/suit 1.png',
      "colors": [Colors.brown[200]!, Colors.black]
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showArrowBack: _currentIndex != 0,
        isSearching: _isSearching,
        languageNotification: _currentIndex != 5,
        settings: _currentIndex == 5,
        onSearchTap: () => setState(() => _isSearching = true),
        onCloseSearch: () => setState(() {
          _isSearching = false;
          _searchQuery = "";
        }),
        onSearchChanged: (value) => setState(() => _searchQuery = value),
        onBackTap: () => setState(() => _currentIndex = 0),
      ),
      body: _isSearching
          ? _buildSearchOverlay(screenHeight, screenWidth)
          : IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeContent(screenHeight, screenWidth),
                WishlistScreen(
                  wishItems: _wishlistItems,
                  onToggle: _toggleWishlist,
                ),
                const NewArrivalsScreen(),
                const CollectionsScreen(),
                CartScreen(),
                ProfileScreen(),
                SettingsScreen(),
              ],
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
            _isSearching = false;
          });
        },
      ),
    );
  }

  Widget _buildHomeContent(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner
          Stack(
            children: [
              Image.asset('assets/images/new_collection.png',
                  width: double.infinity, height: screenHeight * 0.25, fit: BoxFit.cover),
              Positioned(
                bottom: 15,
                right: 15,
                child: ElevatedButton(
                  onPressed: () => setState(() => _currentIndex = 3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D0C0C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('shop now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          _buildHeader("Collections", () => setState(() => _currentIndex = 3)),
          SizedBox(
            height: screenHeight * 0.22,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCollectionItem("Shirts", 'assets/images/white cotton shirt 1.png', screenHeight, screenWidth),
                _buildCollectionItem("Pants", 'assets/images/white cotton shirt 1.png', screenHeight, screenWidth),
                _buildCollectionItem("Dresses", 'assets/images/white cotton shirt 1.png', screenHeight, screenWidth),
              ],
            ),
          ),
          _buildHeader("New Arrivals", () => setState(() => _currentIndex = 2)),
          FutureBuilder<List<dynamic>>(
            future: fetchNewArrivals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator(color: Color(0xFF4D0C0C))));
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("Unable to load latest items", style: TextStyle(color: Colors.grey)),
                );
              }

              final apiProducts = snapshot.data!.take(2).toList();

              return _buildProductGrid(
                apiProducts.map((p) => _buildItemCardFromData(p)).toList(),
                screenHeight,
                screenWidth,
              );
            },
          ),
          _buildHeader("Winter 2026", () => setState(() => _currentIndex = 3)),
          _buildProductGrid([
            _buildItemCardFromData(_allProducts[2]),
            _buildItemCardFromData(_allProducts[3]),
          ], screenHeight, screenWidth),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildItemCardFromData(Map<String, dynamic> p) {
    List<Color> extractedColors = [Colors.black, Colors.grey];
    if (p['colors'] != null && p['colors'] is List && p['colors'].isNotEmpty) {
      if (p['colors'][0] is Map) {
        // إذا كانت بيانات API (hex_code)
        extractedColors = (p['colors'] as List).map((c) {
          String hex = c['hex_code'].toString().replaceAll('#', '');
          return Color(int.parse("FF$hex", radix: 16));
        }).toList();
      } else {
        extractedColors = List<Color>.from(p['colors']);
      }
    }

    return ItemCard(
      title: p['name'] ?? p['title'] ?? 'Product',
      price: p['price_display'] ?? p['price']?.toString() ?? '0 EGP',
      imagePath: p['image_url'] ?? p['image'] ?? '',
      oldPrice: p['discount_price']?.toString(),
      discount: p['discount_label'] ?? p['discount'],
      colors: extractedColors,
      isFavorite: _wishlistItems.any((item) => 
        (item['id'] != null && item['id'] == p['id']) || 
        (item['title'] == p['title'] && item['title'] != null)
      ),
      onFavoriteTap: () => _toggleWishlist(p),
    );
  }

  Widget _buildSearchOverlay(double screenHeight, double screenWidth) {
    final filteredResults = _allProducts.where((product) {
      return product['title'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      color: Colors.white,
      child: _searchQuery.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: screenWidth * 0.2, color: Colors.grey[200]),
                  const Text("Search for your favorite outfits", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : filteredResults.isEmpty
              ? Center(child: Text("No items found for '$_searchQuery'"))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredResults.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.55,
                  ),
                  itemBuilder: (context, index) => _buildItemCardFromData(filteredResults[index]),
                ),
    );
  }

  Widget _buildHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'serif')),
          InkWell(onTap: onTap, child: const Text("View All →", style: TextStyle(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Widget> items, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.55, // نسبة العرض للطول لضمان عدم ظهور أخطاء overflow
        children: items,
      ),
    );
  }

  Widget _buildCollectionItem(String title, String path, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(path, height: screenHeight * 0.15, width: screenWidth * 0.3, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF4D0C0C), fontWeight: FontWeight.w600)),
              const Icon(Icons.arrow_right_alt, size: 18, color: Color(0xFF4D0C0C)),
            ],
          ),
        ],
      ),
    );
  }
}