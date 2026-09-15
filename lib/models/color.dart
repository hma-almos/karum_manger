import 'dart:convert';
import 'package:flutter/material.dart';

// ==========================================
// 1. AppColor Model
// ==========================================
class ProductColor {
  final Color color;
  final String name;
  final int count;

  const ProductColor({
    required this.color,
    required this.count,
    required this.name,
  });

  ProductColor copyWith({
    Color? color,
    int? count,
    String? name,
  }) {
    return ProductColor(
      color: color ?? this.color,
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color.value, // Stores Color as an integer ARGB value
      'count': count,
    };
  }

  factory ProductColor.fromMap(Map<String, dynamic> map) {
    return ProductColor(
      color: Color(map['color'] as int),
      count: map['count'] as int? ?? 0,
      name: map['name'] as String? ?? ""
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductColor.fromJson(String source) =>
      ProductColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppColor(color: $color, count: $count)';
}