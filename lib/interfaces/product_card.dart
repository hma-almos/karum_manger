import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karum_manger/interfaces/print_detailds.dart';
import 'package:karum_manger/interfaces/show_prodect.dart';
import 'package:karum_manger/models/abstract_product.dart';
import 'package:karum_manger/models/print_product.dart';
import 'package:karum_manger/models/prodect.dart';

class ProductCard extends StatelessWidget {
  final AbstractProduct product;
  final VoidCallback onCartUpdated;

  const ProductCard({
    super.key,
    required this.product,
    required this.onCartUpdated,
  });
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF535170);
    final NumberFormat formatter = NumberFormat('#,##0', 'en_US');
    final currentProduct = product;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        
        child: InkWell(
          onTap: () =>_toggleCartStatus(context),

          borderRadius: BorderRadius.circular(20),            
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: currentProduct is PrintProduct
                        ? Image.asset(
                            currentProduct.positions.isNotEmpty ? currentProduct.positions[0].imageUrl : '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 32),
                          )
                        :currentProduct is Product? Image.network(
                            currentProduct.pictures.isNotEmpty ? currentProduct.pictures[0] : '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 32),
                          ):null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2B3E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatter.format(product.price)} د.ع',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _toggleCartStatus(BuildContext context) async {
    final currentProduct = product;
    final dynamic result;
   if (currentProduct is PrintProduct) {
              result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FixedPrintCustomizer(product:currentProduct ,),
                ),
              );
            } else if(currentProduct is Product){
              // Open Product Detail Screen
              result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: currentProduct),
                ),
              );
              }else{result=null;}
             
              onCartUpdated();
          }
}