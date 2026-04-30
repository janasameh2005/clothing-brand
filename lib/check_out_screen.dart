import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // تأكدي من إضافة http في pubspec.yaml
import 'dart:convert';
import 'custom_appbar.dart';
import 'apptheme.dart';

class CheckoutScreen extends StatefulWidget {
  final String subTotal;
  final String total;

  const CheckoutScreen({
    super.key,
    this.subTotal = "0 EGP",
    this.total = "0 EGP",
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  Future<void> processCheckout() async {
    const String checkoutUrl = "https://uncurled-resolute-ducky.ngrok-free.dev/checkout";
    const String paymentUrl = "https://uncurled-resolute-ducky.ngrok-free.dev/checkout/payment";

    try {
      final checkoutResponse = await http.post(
        Uri.parse(checkoutUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "subtotal": widget.subTotal,
          "total": widget.total,
        }),
      );
      if (selectedPaymentMethod == "MasterCard") {
        final paymentResponse = await http.post(
          Uri.parse(paymentUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "method": selectedPaymentMethod,
            "card_number": cardNumberController.text,
            "expiry": expiryDateController.text,
            "cvv": cvvController.text,
          }),
        );
        
        if (paymentResponse.statusCode == 200) {
           print("Payment details sent successfully");
        }
      }

      if (checkoutResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Placed Successfully!")),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Checkout",
                      style: Apptheme.textTheme.displaySmall?.copyWith(
                          fontFamily: 'Serif', fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Payment Method (Optional)",
                    style: Apptheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  // جزء اختيار الدفع
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _paymentIcon(Icons.credit_card, "MasterCard"),
                      _paymentIcon(Icons.paypal, "PayPal"),
                      _paymentIcon(Icons.payment, "Visa"),
                    ],
                  ),
                  
                  if (selectedPaymentMethod == "MasterCard") ...[
                    const SizedBox(height: 30),
                    const Divider(color: Color(0xFFE5D0AC)),
                    const SizedBox(height: 10),
                    Text(
                      "Card Details",
                      style: Apptheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildFieldLabel("Card Number"),
                    _buildTextField("XXXX XXXX XXXX XXXX", cardNumberController, keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("Expiry Date"),
                              _buildTextField("MM/YY", expiryDateController, keyboardType: TextInputType.datetime),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("Enter CVV"),
                              _buildTextField("CVV", cvvController, keyboardType: TextInputType.number, obscureText: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomSummary(context, "Place Order", widget.subTotal, widget.total, processCheckout),
        ],
      ),
    );
  }

  Widget _paymentIcon(IconData icon, String label) {
    bool isSelected = selectedPaymentMethod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = isSelected ? null : label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Apptheme.accentDark, width: 2)
              : Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Apptheme.accentDark : Colors.grey, size: 30),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {TextInputType? keyboardType, bool obscureText = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Apptheme.greyText),
        filled: true,
        fillColor: const Color(0xFF8F8B7B).withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 5),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // دالة الـ Bottom Summary (total/subtotal) تستخدم widget.subTotal للوصول للقيم
  Widget _buildBottomSummary(BuildContext context, String buttonText, String subTotalVal, String totalVal, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Apptheme.greyText.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sub Total", style: Apptheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(subTotalVal, style: Apptheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Apptheme.primaryBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: Apptheme.textTheme.headlineSmall?.copyWith(color: Apptheme.black, fontWeight: FontWeight.bold)),
                    Text(totalVal, style: Apptheme.textTheme.headlineSmall?.copyWith(color: Apptheme.black, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Apptheme.accentDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: Text(buttonText, style: TextStyle(color: Apptheme.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}