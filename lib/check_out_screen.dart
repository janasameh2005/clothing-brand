import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http; 
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
  bool isAgreed = false;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  Future<void> processCheckout() async {
    if (selectedPaymentMethod == null) {
      _showSnackBar("Please select a payment method");
      return;
    }
    if (selectedPaymentMethod == "Visa" && !isAgreed) {
      _showSnackBar("Please agree to the terms to proceed with Visa");
      return;
    }

    const String checkoutUrl = "https://88myhsysdelr.shares.zrok.io/api/checkout";
    const String paymentUrl = "https://88myhsysdelr.shares.zrok.io/api/checkout/payment";

    try {
      final checkoutResponse = await http.post(
        Uri.parse(checkoutUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "subtotal": widget.subTotal,
          "total": widget.total,
          "method": selectedPaymentMethod,
        }),
      );

      if (selectedPaymentMethod == "Visa") {
        await http.post(
          Uri.parse(paymentUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "method": selectedPaymentMethod,
            "card_number": cardNumberController.text,
            "expiry": expiryDateController.text,
            "cvv": cvvController.text,
          }),
        );
      }

      if (checkoutResponse.statusCode == 200) {
        _showSnackBar("Order Placed Successfully!");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                    "Payment Method",
                    style: Apptheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _paymentIcon(Icons.money, "Cash"),
                      _paymentIcon(Icons.payment, "Visa"),
                    ],
                  ),
                  if (selectedPaymentMethod == "Cash") ...[
                    const SizedBox(height: 30),
                    const Divider(color: Color(0xFFE5D0AC)),
                    const SizedBox(height: 20),
                    _buildInfoBox(
                      Icons.delivery_dining,
                      "Cash on Delivery: Please ensure you have the exact amount ready upon arrival.",
                    ),
                  ],
                  if (selectedPaymentMethod == "Visa") ...[
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
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => setState(() => isAgreed = !isAgreed),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAgreed,
                            activeColor: Apptheme.accentDark,
                            onChanged: (value) => setState(() => isAgreed = value!),
                          ),
                          const Expanded(
                            child: Text(
                              "Save card details ",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Apptheme.accentDark),
                            ),
                          ),
                        ],
                      ),
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
      onTap: () => setState(() => selectedPaymentMethod = isSelected ? null : label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Apptheme.accentDark : Apptheme.greyText, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
          color: Apptheme.white,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Apptheme.accentDark : Apptheme.greyText, size: 30),
            Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Apptheme.accentDark : Apptheme.greyText)),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoBox(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8F8B7B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5D0AC).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Apptheme.accentDark, size: 30),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: TextStyle(color: Apptheme.accentDark, fontWeight: FontWeight.w500))),
        ],
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

  Widget _buildBottomSummary(BuildContext context, String buttonText, String subTotalVal, String totalVal, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Apptheme.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
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