import 'dart:convert';
import 'package:karum_manger/models/abstract_product.dart';
import 'package:karum_manger/models/print_postion.dart';
import 'package:karum_manger/models/size.dart';
class PrintProduct extends AbstractProduct{
  final List<PrintPosition> positions;
  String? pictureUrl;

   PrintProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.supplier,
    required super.incart,
    required this.positions,
    this.pictureUrl,
    required super.category,
    required super.sizes,
  });

  PrintProduct copyWith({
    String? id,
    List<String>? pictures,
    double? price,
    String? description,
    List<ProductSize>? sizes,
    String? name,
    String? supplier,
    bool? incart,
    List<PrintPosition>? positions,
    String? pictureUrl,
    String? category,
  }) {
    return PrintProduct(
      id: id ?? super.id,
      price: price ?? super.price,
      name: name ?? super.name,
      supplier: supplier?? super.supplier,
      incart: incart ?? super.incart,
      positions: positions?? this.positions,
      pictureUrl: pictureUrl??this.pictureUrl,
      category: category?? super.category,
      sizes: sizes ?? super.sizes
    );
  }
 Map<String, dynamic> toMap() {
    return {
      'type': 'print_product',
      'id': id,
      'name': name,
      'price': price,
      'supplier': supplier,
      'incart': incart,
      // Map each PrintPosition instance to a Map
      'positions': positions.map((p) => p.toMap()).toList(),
      'pictureUrl':pictureUrl,
      'category': category,
      'sizes': sizes.map((x) => x.toMap()).toList(),
    };
  }
  @override
  factory PrintProduct.fromMap(Map<String, dynamic> map) {
    return PrintProduct(
      id: map['id'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
        name: map['name'] as String? ?? '',
        supplier: map['supplier'] as String? ?? '',
        incart: map['incart'] as bool? ?? false,
        positions: (map['positions'] as List<dynamic>?)
              ?.map((x) => PrintPosition.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],    
          pictureUrl: map['pictureUrl'] as String? ?? '',
          category:map['category']as String? ?? '',
           sizes: (map['sizes'] as List<dynamic>?)
              ?.map((x) => ProductSize.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
          );
  }

  String toJson() => json.encode(toMap());

  factory PrintProduct.fromJson(String source) =>
      PrintProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}