import 'package:flutter/material.dart';
import 'package:karum_manger/models/order_details.dart';
import 'package:intl/intl.dart' hide TextDirection;

class OrderCardWidget extends StatelessWidget {
  final OrderDetails orderDetails;
  // final VoidCallback onTap;

  const OrderCardWidget({
    Key? key,
    required this.orderDetails,
    // required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');

    // Price Calculations
    final int itemCount = orderDetails.products.length;
    final double rawTotal =
        orderDetails.products.fold(0, (sum, item) => sum + item.price);

    final bool hasDiscount = itemCount >= 5;

    // Calculate discounted price based on formula
    final double calculatedDiscounted =
        rawTotal - ((6000 * orderDetails.products.length) * 0.3);

    // Round down to the nearest 1,000
    final double finalPrice = hasDiscount
        ? ((calculatedDiscounted ~/ 1000) * 1000).toDouble()
        : rawTotal;

    // Supplier Existence Checks
    final bool hasNajmaSupplier = orderDetails.products
        .any((element) => element.supplier == 'نجمة');
    final bool hasLahthaSupplier = orderDetails.products
        .any((element) => element.supplier == 'لحظة');

    return GestureDetector(
      onTap: ()=>{
        
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFF4A4960), // Dark grey/purple border
            width: 3.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Price on left, Location info & Icon on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price text area (Left aligned)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display Original Price with Line-through if Discounted
                    if (hasDiscount)
                      Text(
                        '${formatter.format(rawTotal)} د.ع',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red.shade400,
                          decorationThickness: 2.0,
                        ),
                      ),
                    // Final / Discounted Price
                    Text(
                      '${formatter.format(finalPrice)} د.ع',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: hasDiscount ? const Color(0xFF2E7D32) : Colors.black, // Subtle green when discounted
                      ),
                    ),
                  ],
                ),

                // Location Details + Icon (Right aligned)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          orderDetails.governorate,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orderDetails.detailedAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Boxes Icon
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 40,
                      color: Color(0xFF4A4960),
                    ),
                  ],
                ),
              ],
            ),

            // Only show spacing and chips row if at least one supplier exists
            if (hasNajmaSupplier || hasLahthaSupplier) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (hasNajmaSupplier)
                    _buildChip(
                      text: 'نجمة',
                      backgroundColor: const Color(0xFFE5B537), // Yellow chip
                      borderColor: const Color(0xFF4A4960),
                    ),
                  if (hasNajmaSupplier && hasLahthaSupplier)
                    const SizedBox(width: 10),
                  if (hasLahthaSupplier)
                    _buildChip(
                      text: 'لحظة',
                      backgroundColor: const Color(0xFF3BA2D0), // Blue chip
                      borderColor: const Color(0xFF4A4960),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget for provider pills
  Widget _buildChip({
    required String text,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}