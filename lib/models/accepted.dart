import 'package:karum_manger/models/order_details.dart';

class Accepted {
  final DateTime date;
  final int price;
  final OrderDetails order;

  const Accepted({
    required this.date,
    required this.price,
    required this.order,
  });

  // Create an object from a Map (useful for API or Firebase responses)
  factory Accepted.fromMap(Map<String, dynamic> map,String orderId) {
    return Accepted(
      date: map['date'] is String 
          ? DateTime.parse(map['date']) 
          : (map['date'] as DateTime),
      price: (map['price'] as num).toInt(),
      order: OrderDetails.fromMap(map['order'] as Map<String, dynamic>,orderId),
    );
  }

  // Convert the object to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'price': price,
      'order': order.toMap(),
    };
  }

  // Helper method to clone/update fields conveniently
  Accepted copyWith({
    DateTime? date,
    int? price,
    OrderDetails? order,
  }) {
    return Accepted(
      date: date ?? this.date,
      price: price ?? this.price,
      order: order ?? this.order,
    );
  }
}