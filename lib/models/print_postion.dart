import 'package:flutter/material.dart';

class PrintPosition {
  final String id;
  final String titleAr;
  final String imageUrl;
  final Alignment printAlignment;
  final Size printAreaSize;
  final List<String> availableSizes;

  PrintPosition({
    required this.id,
    required this.titleAr,
    required this.imageUrl,
    required this.printAlignment,
    required this.printAreaSize,
    required this.availableSizes,
  });

  PrintPosition copyWith({
    String? id,
    String? titleAr,
    String? imageUrl,
    Alignment? printAlignment,
    Size? printAreaSize,
    List<String>? availableSizes,
  }) {
    return PrintPosition(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      imageUrl: imageUrl ?? this.imageUrl,
      printAlignment: printAlignment ?? this.printAlignment,
      printAreaSize: printAreaSize ?? this.printAreaSize,
      availableSizes: availableSizes ?? this.availableSizes,
    );
  }

  // 1. Serialize to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_ar': titleAr,
      'image_url': imageUrl,
      'alignment': {
        'x': printAlignment.x,
        'y': printAlignment.y,
      },
      'size': {
        'width': printAreaSize.width,
        'height': printAreaSize.height,
      },
      'available_sizes': availableSizes,
    };
  }

  // 2. Deserialize from Firestore Map
  factory PrintPosition.fromMap(Map<String, dynamic> map) {
    final alignmentMap = map['alignment'] as Map<String, dynamic>? ?? {};
    final sizeMap = map['size'] as Map<String, dynamic>? ?? {};

    return PrintPosition(
      id: map['id'] as String? ?? '',
      titleAr: map['title_ar'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      printAlignment: Alignment(
        (alignmentMap['x'] as num?)?.toDouble() ?? 0.0,
        (alignmentMap['y'] as num?)?.toDouble() ?? 0.0,
      ),
      printAreaSize: Size(
        (sizeMap['width'] as num?)?.toDouble() ?? 0.0,
        (sizeMap['height'] as num?)?.toDouble() ?? 0.0,
      ),
      availableSizes: (map['available_sizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}