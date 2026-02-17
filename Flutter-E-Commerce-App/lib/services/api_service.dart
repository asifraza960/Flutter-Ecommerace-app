import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ApiService {
  final Dio _dio;
  static const String baseUrl = 'https://fakestoreapi.com';

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // Product APIs
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Cart APIs
  Future<List<Cart>> getUserCarts(int userId) async {
    try {
      final response = await _dio.get('/carts/user/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => Cart.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // User APIs
  Future<User> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Authentication APIs
  Future<AuthUser> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());

      // FakeStoreAPI returns just a token, so we need to get user details
      final token = response.data['token'] as String;

      // For demo, we'll use a mock user with the token
      // In production, you'd fetch actual user details with the token
      return AuthUser(
        id: 1, // Default user ID for demo
        email: request.username,
        username: request.username,
        token: token,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthUser> register(RegisterRequest request) async {
    try {
      // FakeStoreAPI's user creation endpoint
      final response = await _dio.post('/users', data: request.toJson());

      // Generate a mock token for the new user
      final userId = response.data['id'] as int;

      return AuthUser(
        id: userId,
        email: request.email,
        username: request.username,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
