import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';


class ApiService {
  // اللينك اللي جربناه في Postman
  final String url = "https://g3bfvqjf-8000.uks1.devtunnels.ms/api/profile/";

  Future<ProfileResponse?> fetchProfileData() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // لو الـ Backend طلب Token لاحقاً، هيتحط هنا
        },
      );

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        // اطبعي الـ body هنا عشان تشوفي المشكلة فين (مثلاً محتاج Token)
        print("Error Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("فشل الاتصال بالإنترنت: $e");
      return null;
    }
  }
}