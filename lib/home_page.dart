import 'package:clothing_brand/profile_screen.dart';
import 'package:clothing_brand/settings.dart';
import 'package:flutter/material.dart';
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

  void _toggleWishlist(Map<String, dynamic> product) {
    setState(() {
      bool isExist = _wishlistItems.any((item) => item['title'] == product['title']);
      if (isExist) {
        _wishlistItems.removeWhere((item) => item['title'] == product['title']);
      } else {
        _wishlistItems.add(product);
      }
    });
  }

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
    {
      "title": "White Shirt",
      "price": "850 EGP",
      "image": 'assets/images/white cotton shirt 1.png',
      "colors": [Colors.white]
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
          :IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(screenHeight, screenWidth),
          WishlistScreen(
            wishItems: _wishlistItems,
            onToggle: _toggleWishlist,
          ),
          const NewArrivalsScreen(),
          const CollectionsScreen(),
          const Center(child: Text("Cart Page")),
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
            const SizedBox(height: 10),
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
          childAspectRatio: (screenWidth / 2) / (screenHeight * 0.45),
        ),
        itemBuilder: (context, index) {
          final p = filteredResults[index];
          return ItemCard(
            title: p['title'],
            price: p['price'],
            imagePath: p['image'],
            oldPrice: p['oldPrice'],
            discount: p['discount'],
            colors: List<Color>.from(p['colors']),
            isFavorite: _wishlistItems.any((item) => item['title'] == p['title']),
            onFavoriteTap: () => _toggleWishlist(p),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset('assets/images/new_collection.png', width: double.infinity, height: screenHeight * 0.25, fit: BoxFit.cover),
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
          _buildProductGrid([
            _buildItemCardFromMap(_allProducts[0]),
            _buildItemCardFromMap(_allProducts[1]),
          ], screenHeight, screenWidth),
          _buildHeader("Winter 2026", () => setState(() => _currentIndex = 3)),
          _buildProductGrid([
            _buildItemCardFromMap(_allProducts[2]),
            _buildItemCardFromMap(_allProducts[3]),
          ], screenHeight, screenWidth),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItemCardFromMap(Map<String, dynamic> p) {
    return ItemCard(
      title: p['title'],
      price: p['price'],
      imagePath: p['image'],
      oldPrice: p['oldPrice'],
      discount: p['discount'],
      colors: List<Color>.from(p['colors']),
      isFavorite: _wishlistItems.any((item) => item['title'] == p['title']),
      onFavoriteTap: () => _toggleWishlist(p),
    );
  }

  Widget _buildHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'serif')),
          InkWell(onTap: onTap, child: const Text("View All →", style: TextStyle(fontSize: 12, color: Colors.black))),
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
        childAspectRatio: (screenWidth / 2) / (screenHeight * 0.45),
        children: items,
      ),
    );
  }

  Widget _buildCollectionItem(String title, String path, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Image.asset(path, height: screenHeight * 0.17, width: screenWidth * 0.3, fit: BoxFit.cover),
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