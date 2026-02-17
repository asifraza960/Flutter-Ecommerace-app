import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../services/api_service.dart';

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Map<int, CartItemWithProduct> items;

  const CartLoaded({required this.items});

  double get totalAmount {
    double total = 0;
    for (var item in items.values) {
      total += item.product.price * item.quantity;
    }
    return total * 280; // Convert USD to PKR (1 USD = 280 PKR approx)
  }

  int get totalItems {
    return items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

// Helper class to combine product and quantity
class CartItemWithProduct {
  final Product product;
  final int quantity;

  CartItemWithProduct({required this.product, required this.quantity});

  CartItemWithProduct copyWith({int? quantity}) {
    return CartItemWithProduct(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemWithProduct &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id &&
          quantity == other.quantity;

  @override
  int get hashCode => product.id.hashCode ^ quantity.hashCode;
}

// Cubit
class CartCubit extends Cubit<CartState> {
  CartCubit(ApiService apiService) : super(CartInitial());

  // Initialize with empty cart
  void initializeCart() {
    emit(const CartLoaded(items: {}));
  }

  // Add product to cart
  void addToCart(Product product, {int quantity = 1}) {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = Map<int, CartItemWithProduct>.from(
        currentState.items,
      );

      if (updatedItems.containsKey(product.id)) {
        // Update quantity if product already exists
        final existingItem = updatedItems[product.id]!;
        updatedItems[product.id] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        // Add new product
        updatedItems[product.id] = CartItemWithProduct(
          product: product,
          quantity: quantity,
        );
      }

      emit(CartLoaded(items: updatedItems));
    }
  }

  // Remove product from cart
  void removeFromCart(int productId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = Map<int, CartItemWithProduct>.from(
        currentState.items,
      );
      updatedItems.remove(productId);
      emit(CartLoaded(items: updatedItems));
    }
  }

  // Update quantity
  void updateQuantity(int productId, int newQuantity) {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = Map<int, CartItemWithProduct>.from(
        currentState.items,
      );

      if (newQuantity <= 0) {
        updatedItems.remove(productId);
      } else if (updatedItems.containsKey(productId)) {
        updatedItems[productId] = updatedItems[productId]!.copyWith(
          quantity: newQuantity,
        );
      }

      emit(CartLoaded(items: updatedItems));
    }
  }

  // Clear cart
  void clearCart() {
    emit(const CartLoaded(items: {}));
  }
}
