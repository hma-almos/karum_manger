import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karum_manger/models/category.dart';
import 'package:karum_manger/models/color.dart';
import 'package:karum_manger/models/prodect.dart';
import 'package:flutter/material.dart';
import 'package:karum_manger/models/size.dart';
class LahthaService {
  static const String _baseUrl =
      'https://apbackendi.lahtha.store';

  static const String _origin =
      'https://click.maysite.top';

  static const String _referer =
      'https://click.maysite.top/';

  static const Map<String, String> _headers = {
    'Accept': '*/*',
    'Accept-Language': 'ar,en-US;q=0.9,en;q=0.8',
    'Origin': _origin,
    'Referer': _referer,
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/147.0.0.0 Safari/537.36',
  };
  static List<Category> categories=[];
  Future<Map<String, dynamic>> getStorefront({
    String slug='click',
    int page = 1,
    int pageSize = 30,
    int? category,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/method/lahtha.api.store_public.get_storefront',
    ).replace(
      queryParameters: {
        'slug': slug,
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (category != null) 'category': category.toString(),      
        },
    );

    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'API Error ${response.statusCode}: ${response.body}',
      );
    }
    Map<String, dynamic> result=Map<String, dynamic>.from(
      jsonDecode(response.body),
    );
    // debugPrint('${jsonDecode(response.body)['message']['products']}=============================');
    return result;
  }

  Product mapJsonToProduct(
    Map<String, dynamic> json, {
    String baseUrl = 'https://apbackendi.lahtha.store/',
    String defaultSupplier = 'لحظة',
    String defaultCategory = 'Uncategorized',
    bool inCart = false,
  }) {
    // 1. Process Images/Pictures
    final rawImages = json['images'] as List<dynamic>? ?? [];
    final List<String> parsedPictures = rawImages.map((img) {
      final path = img.toString();
      return path.startsWith('/') ? '$baseUrl$path' : path;
    }).toList();

    // 2. Parse & Group Variants into ProductSize and ProductColor
    final rawVariants = json['variants'] as List<dynamic>? ?? [];
    final Map<String, List<ProductColor>> sizeToColorsMap = {};

    for (final v in rawVariants) {
      final variantMap = v as Map<String, dynamic>;
      final sizeName = variantMap['size'] as String? ?? 'Standard';
      final colorHexStr = variantMap['color_code'] as String? ?? '#000000';
      final colorName = variantMap['color'] as String? ?? '';

      final Color colorObj = parseHexColor(colorHexStr);

      final productColor = ProductColor(
        color: colorObj,
        count: 1,
        name: colorName,
      );

      sizeToColorsMap.putIfAbsent(sizeName, () => []).add(productColor);
    }

    // Convert grouped map to List<ProductSize>
    final List<ProductSize> parsedSizes = sizeToColorsMap.entries.map((entry) {
      return ProductSize(
        size: entry.key,
        colors: entry.value,
      );
    }).toList();

    // 3. Construct and Return Product
    return Product(
      id: json['id'] as String? ?? '',
      name: json['title'] as String? ?? '',
      pictures: parsedPictures,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      sizes: parsedSizes,
      supplier: defaultSupplier,
      incart: inCart,
      category: json['type'] as String? ?? defaultCategory,
    );
  }

  /// Helper function to parse hex strings like "#fff", "#FFFFFF", or "0xFFFFFFFF"
  Color parseHexColor(String hexString) {
    String cleanHex = hexString.replaceAll('#', '').trim();

    // Expand 3-digit shorthand hex (#fff -> #ffffff)
    if (cleanHex.length == 3) {
      cleanHex = cleanHex.split('').map((c) => '$c$c').join();
    }

    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }

    return Color(int.parse(cleanHex, radix: 16));
  }
  Future<List<Product>> getProductsFromResult({int? category,int itemsCount=30,int page = 1,}) async {  
  final List<Product> products = [];

  // Pass category directly as int?
  final storefrontData = await getStorefront(category: category,pageSize: itemsCount, page:page);

  final message = storefrontData['message'];
  if (message is! Map<String, dynamic>) {
    return products;
  }

  // 1. Safely handle categories
  if (categories.isEmpty) {
    final catList = message['categories'];
    // Check if catList is actually a List before looping
    if (catList is List) {
      for (final catJson in catList) {
        if (catJson is Map<String, dynamic>) {
          Category catigory = Category.fromMap(catJson);
          categories.add(catigory);
        }
      }
    }
  }

  // 2. Safely handle products
  final productList = message['products'];
  // Check if productList is actually a List before looping
  if (productList is List) {
    for (final productJson in productList) {
      if (productJson is Map<String, dynamic>) {
        final product = mapJsonToProduct(productJson);
        products.add(product);
      }
    }
  }

  return products;
}
  Future<List<Category>> fetchCategories() async {
        debugPrint('==============${categories.length}');

    if (categories.isNotEmpty) return categories;
        debugPrint('==============${categories.length}');

    final response = await getStorefront();
    final message = response['message'];
        debugPrint('==============${categories.length}');

    if (message is Map<String, dynamic> && message.containsKey('categories')) {
      final catList = message['categories'] as List<dynamic>? ?? [];
      categories = catList.map((catJson) => Category.fromMap(catJson)).toList();
    }
        debugPrint('==============${categories.length}');

    return categories;
  }
}