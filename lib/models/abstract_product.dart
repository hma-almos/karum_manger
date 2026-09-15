import 'package:karum_manger/models/print_product.dart';
import 'package:karum_manger/models/prodect.dart';
import 'package:karum_manger/models/size.dart';

abstract class AbstractProduct {
  final String id;
  final String name;
  final double price;
  final String supplier;
  bool incart;
  final String category;
  final List<ProductSize> sizes;

  
   AbstractProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.supplier,
    required this.incart,
    required this.category,
    required this.sizes,
  });
   Map<String, dynamic> toMap();
   factory AbstractProduct.fromMap(Map<String, dynamic> map) {
    final String type = map['type'] as String? ?? 'product';

    switch (type) {
      case 'print_product':
        return PrintProduct.fromMap(map);
      case 'product':
      default:
        return Product.fromMap(map);
    }
  }
}