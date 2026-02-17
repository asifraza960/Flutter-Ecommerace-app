import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final int id;
  final int userId;
  final String date;
  final List<CartItem> products;

  const Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: json['date'] as String,
      products: (json['products'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, userId, date, products];
}

class CartItem extends Equatable {
  final int productId;
  final int quantity;

  const CartItem({required this.productId, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }

  @override
  List<Object?> get props => [productId, quantity];
}
