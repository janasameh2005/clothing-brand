import 'package:clothing_brand/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_details_cubit.dart';

class ItemCard extends StatefulWidget {
  final int id;
  final String title;
  final String price;
  final String imagePath;
  final List<Color> colors;
  final String? oldPrice;
  final String? discount;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ItemCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.colors,
    this.oldPrice,
    this.discount,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late bool isFavoriteLocal;

  @override
  void initState() {
    super.initState();
    isFavoriteLocal = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // تحديد طول ثابت للصورة عشان الكروت كلها تبقي موحدة
        SizedBox(
          height: 200, // تقدري تغيري الرقم ده حسب الحجم اللي تحبيه
          child: Stack(
            children: [
              // الصورة الأساسية
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                child: widget.imagePath.startsWith('http')
                    ? Image.network(widget.imagePath, fit: BoxFit.cover)
                    : Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
              // الأزرار فوق الصورة من الأسفل
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    // زرار shop
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ProductDetailsCubit()..loadProductDetails(widget.id),
                                child: ProductDetailsScreen(productId: widget.id),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.black),
                              SizedBox(width: 4),
                              Text('shop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // زرار favorite
                    GestureDetector(
                      onTap: () {
                        setState(() => isFavoriteLocal = !isFavoriteLocal);
                        if (widget.onFavoriteTap != null) widget.onFavoriteTap!();
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavoriteLocal ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: isFavoriteLocal ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // بيانات المنتج
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'serif'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          widget.price,
          style: const TextStyle(color: Color(0xFF4D0C0C), fontWeight: FontWeight.bold, fontSize: 13),
        ),
        // الألوان
        if (widget.colors.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: widget.colors.map((color) => Container(
              margin: const EdgeInsets.only(right: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            )).toList(),
          ),
        ],
      ],
    );
  }
}