import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl = "https://uncurled-resolute-ducky.ngrok-free.dev";

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: "https://uncurled-resolute-ducky.ngrok-free.dev",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map) {
        if (data.containsKey('message')) return Exception(data['message']);
        if (data.containsKey('error')) return Exception(data['error']);
        // Handle field-specific errors (e.g., {"email": ["This field is required"]})
        final buffer = StringBuffer();
        data.forEach((key, value) {
          if (value is List) {
            buffer.writeln("$key: ${value.join(", ")}");
          } else {
            buffer.writeln("$key: $value");
          }
        });
        if (buffer.isNotEmpty) return Exception(buffer.toString().trim());
      }
      return Exception('Server Error: ${e.response?.statusCode}');
    } else {
      return Exception(e.message ?? 'Unknown error occurred');
    }
  }
}
