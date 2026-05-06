import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_mock_data.dart'; // الملف اللي لسه عاملينه

class ApiService {
  Future<Map<String, dynamic>> getProductDetails(int productId) async {
    final String url = "https://10cxyvxk6z8u.shares.zrok.io/api/products/$productId/";

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        print("Data loaded from Server");
        return json.decode(response.body);
        // ... جوه الـ ApiService
      } else {
        print("Server error, loading Mock Data...");
        return ProductMockData.getFallbackData(productId); // شيلنا json.decode
      }
    } catch (e) {
      print("Server Down! Loading Local Mock Data...");
      return ProductMockData.getFallbackData(productId); // شيلنا json.decode
    }
  }
}