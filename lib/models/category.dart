import 'dart:convert';

class Category {
  final String name;
  final int id;

  const Category({
    required this.id,
    required this.name,
  });

  Category copyWith({
    int? id,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int? ?? 0,
      name: map['title'] as String? ?? ""
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

}