import 'package:karum_manger/models/abstract_product.dart';

class OrderDetails {
  final String id;
  final String fullName;
  final String primaryPhone;
  final String? secondaryPhone;
  final String governorate;
  final String detailedAddress;
  final String? notes;
  final List<AbstractProduct> products;

  OrderDetails({
    required this.id,
    required this.fullName,
    required this.primaryPhone,
    this.secondaryPhone,
    required this.governorate,
    required this.detailedAddress,
    this.notes,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'full_name': fullName,
      'primary_phone': primaryPhone,
      'secondary_phone': secondaryPhone ?? '',
      'governorate': governorate,
      'detailed_address': detailedAddress,
      'notes': notes ?? '',
      'products': products.map((product) {
          return product.toMap();        
      }).toList(),
    };
  }

  factory OrderDetails.fromMap(Map<String, dynamic> map,String id) {
    return OrderDetails(
      id:id,
      fullName: map['full_name'] ?? '',
      primaryPhone: map['primary_phone'] ?? '',
      secondaryPhone: map['secondary_phone'],
      governorate: map['governorate'] ?? '',
      detailedAddress: map['detailed_address'] ?? '',
      notes: map['notes']??'',
      products: (map['products'] as List<dynamic>?)
              ?.map((item) => AbstractProduct.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}