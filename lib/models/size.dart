import 'dart:convert';

import 'package:karum_manger/models/color.dart';

class ProductSize {
  final String size;
  final List<ProductColor> colors;

  const ProductSize({
    required this.size,
    required this.colors,
  });

  ProductSize copyWith({
    String? size,
    List<ProductColor>? colors,
  }) {
    return ProductSize(
      size: size ?? this.size,
      colors: colors ?? this.colors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'colors': colors.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductSize.fromMap(Map<String, dynamic> map) {
    return ProductSize(
      size: map['size'] as String? ?? '',
      colors: (map['colors'] as List<dynamic>?)
              ?.map((x) => ProductColor.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductSize.fromJson(String source) =>
      ProductSize.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductSize(size: $size, colors: $colors)';
}