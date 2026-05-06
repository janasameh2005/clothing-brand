import 'package:flutter/material.dart';
import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/cart_model.dart'; 
import 'package:clothing_brand/check_out_screen.dart';
import 'package:clothing_brand/custom_appbar.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final String totalPrice;

  const OrderDetailsScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool saveAddress = false;
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.white,
      appBar: CustomAppBar(showArrowBack: true, languageNotification: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Order Details",
                      style: Apptheme.textTheme.displaySmall?.copyWith(
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (widget.cartItems.isEmpty)
                    const Center(child: Text("Your cart is empty"))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        double calculatedOldPrice = item.price * 1.2;
                        return OrderItemCard(
                          name: item.name,
                          price: "${item.priceDisplay} EGP",
                          oldPrice: "${calculatedOldPrice.toStringAsFixed(0)} EGP"??"0 EGP",
                          color: "N/A",
                          size: "N/A",
                          rating: "4.5/5",
                          imagePath: item.image,
                        );
                      },
                    ),

                  const SizedBox(height: 25),
                  _buildAddressSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomSummary(context),
        ],
      ),
    );
  }
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildLabeledField("Country", "Country", countryController),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildLabeledField("State", "State", stateController),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: _buildLabeledField("City/Town", "City/Town", cityController),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            setState(() {
              saveAddress = !saveAddress;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: saveAddress,
                activeColor: Apptheme.accentDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (value) {
                  setState(() {
                    saveAddress = value!;
                  });
                },
              ),
              const Text(
                "Save Address",
                style: TextStyle(
                  color: Apptheme.accentDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildLabeledField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 15),
      decoration: BoxDecoration(
        color: Apptheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Color(0xFFE5D0AC), thickness: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total", style: Apptheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    widget.totalPrice,
                    style: Apptheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Apptheme.accentDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            total: widget.totalPrice,
                            subTotal: widget.totalPrice,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Apptheme.accentDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text(
                      "Payment",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
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
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imagePath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  headers: const {"ngrok-skip-browser-warning": "true"},
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                  ),
                  child: Text(
                    oldPrice,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Apptheme.accentDark,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
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
          style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.3),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(color: Apptheme.accentDark, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}