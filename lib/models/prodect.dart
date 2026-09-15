import 'dart:convert';
import 'package:karum_manger/models/abstract_product.dart';
import 'package:karum_manger/models/size.dart';
class Product extends AbstractProduct{
  final List<String> pictures;
  final String description;
   Product({
    required super.id,
    required super.name,
    required this.pictures,
    required super.price,
    required this.description,
    required super.sizes,
    required super.supplier,
    required super.incart,
    required super.category,
  });

  Product copyWith({
    String? id,
    List<String>? pictures,
    double? price,
    String? description,
    List<ProductSize>? sizes,
    String? name,
    String? supplier,
    bool? incart,
    String? category,
  }) {
    return Product(
      id: id ?? super.id,
      pictures: pictures ?? this.pictures,
      price: price ?? super.price,
      description: description ?? this.description,
      sizes: sizes ?? super.sizes,
      name: name ?? super.name,
      supplier: supplier?? super.supplier,
      incart: incart ?? super.incart,
      category: category??super.category
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'product',
      'id': id,
      'name':name,
      'pictures': pictures,
      'price': price,
      'description': description,
      'sizes': sizes.map((x) => x.toMap()).toList(),
      'supplier':supplier,
      'category':category,
    };
  }
  @override
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      pictures: List<String>.from(map['pictures'] ?? []),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
      sizes: (map['sizes'] as List<dynamic>?)
              ?.map((x) => ProductSize.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
        name: map['name'] as String? ?? '',
        supplier: map['supplier'] as String? ?? '',
        incart: map['incart'] as bool? ?? false,
        category:map['category'] as String? ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id,name: $name ,pictures: $pictures, price: $price, description: $description, sizes: $sizes)';
  }
}