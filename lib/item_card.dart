import 'package:flutter/material.dart';
import 'product_details_screen.dart';

class ItemCard extends StatefulWidget {
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
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                  ],
                ),
                child:
ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: widget.imagePath.startsWith('http')
      ? Image.network(
          widget.imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
        )
      : Image.asset(
          widget.imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
        ),
),
              ),
              if (widget.discount != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF4D0C0C), borderRadius: BorderRadius.circular(10)),
                    child: Text("-${widget.discount}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    title: widget.title,
                                    price: widget.price,
                                    imagePath: widget.imagePath,
                                    oldPrice: widget.oldPrice,
                                    discount: widget.discount,
                                    isFavorite: isFavoriteLocal,
                                    onFavoriteTap: () {
                                      setState(() {
                                        isFavoriteLocal = !isFavoriteLocal;
                                      });
                                      if (widget.onFavoriteTap != null) widget.onFavoriteTap!();
                                    },
                                  )
                              )
                          );
                        },
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.black),
                              SizedBox(width: 4),
                              Text('shop', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavoriteLocal = !isFavoriteLocal;
                        });
                        if (widget.onFavoriteTap != null) widget.onFavoriteTap!();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Icon(
                            isFavoriteLocal ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFavoriteLocal ? Colors.red : Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'serif'), maxLines: 1, overflow: TextOverflow.ellipsis),
        Row(
          children: [
            Text(widget.price, style: const TextStyle(color: Color(0xFF4D0C0C), fontWeight: FontWeight.bold, fontSize: 13)),
            if (widget.oldPrice != null) ...[
              const SizedBox(width: 5),
              Text(widget.oldPrice!, style: const TextStyle(color: Colors.grey, fontSize: 11, decoration: TextDecoration.lineThrough)),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: widget.colors.map((color) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CircleAvatar(backgroundColor: color, radius: 5),
          )).toList(),
        ),
      ],
    );
  }
}
