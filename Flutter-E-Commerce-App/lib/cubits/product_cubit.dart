import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../services/api_service.dart';

// States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String? selectedCategory;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [products, filteredProducts, selectedCategory];

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? selectedCategory,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ProductCubit extends Cubit<ProductState> {
  final ApiService _apiService;

  ProductCubit(this._apiService) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await _apiService.getAllProducts();
      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> refreshProducts() async {
    try {
      final products = await _apiService.getAllProducts();
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        emit(
          currentState.copyWith(products: products, filteredProducts: products),
        );
      } else {
        emit(ProductLoaded(products: products, filteredProducts: products));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (query.isEmpty) {
        emit(currentState.copyWith(filteredProducts: currentState.products));
      } else {
        final filtered = currentState.products.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(currentState.copyWith(filteredProducts: filtered));
      }
    }
  }

  void filterByCategory(String? category) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (category == null || category.isEmpty) {
        emit(
          currentState.copyWith(
            filteredProducts: currentState.products,
            selectedCategory: null,
          ),
        );
      } else {
        final filtered = currentState.products
            .where((product) => product.category == category)
            .toList();
        emit(
          currentState.copyWith(
            filteredProducts: filtered,
            selectedCategory: category,
          ),
        );
      }
    }
  }
}
