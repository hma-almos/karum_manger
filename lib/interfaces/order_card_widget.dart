import 'package:flutter/material.dart';
import 'package:karum_manger/interfaces/order_details_screen.dart';
import 'package:karum_manger/models/order_details.dart';
import 'package:intl/intl.dart' hide TextDirection;

class OrderCardWidget extends StatelessWidget {
  final OrderDetails orderDetails;
  final VoidCallback? onTap;

  const OrderCardWidget({
    Key? key,
    required this.orderDetails,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');

    // Price Calculations
    final int itemCount = orderDetails.products.length;
    final double rawTotal =
        orderDetails.products.fold(0, (sum, item) => sum + item.price);

    final bool hasDiscount = itemCount >= 5;

    // Calculate discounted price
    final double calculatedDiscounted =
        rawTotal - ((6000 * orderDetails.products.length) * 0.3);

    // Round down to the nearest 1,000
    final double finalPrice = hasDiscount
        ? ((calculatedDiscounted ~/ 1000) * 1000).toDouble()
        : rawTotal;

    // Supplier Checks
    final bool hasNajmaSupplier = orderDetails.products
        .any((element) => element.supplier == 'نجمة');
    final bool hasLahthaSupplier = orderDetails.products
        .any((element) => element.supplier == 'لحظة');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: ()=>{
           Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(orderDetails: orderDetails,),
                ),
              ),
          onTap
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: const Color(0xFF4A4960),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row: Box Icon & Location on Right (RTL Start), Price on Left (RTL End)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + Location Info (Right/Start side in RTL)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 36,
                          color: Color(0xFF4A4960),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderDetails.governorate,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                orderDetails.detailedAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Price Column (Left/End side in RTL)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasDiscount)
                        Text(
                          '${formatter.format(rawTotal)} د.ع',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red.shade400,
                          ),
                        ),
                      Text(
                        '${formatter.format(finalPrice)} د.ع',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: hasDiscount
                              ? const Color(0xFF2E7D32)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Supplier Chips Row
              if (hasNajmaSupplier || hasLahthaSupplier) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hasLahthaSupplier)
                      _buildChip(
                        text: 'لحظة',
                        backgroundColor: const Color(0xFF3BA2D0),
                      ),
                    if (hasNajmaSupplier && hasLahthaSupplier)
                      const SizedBox(width: 8),
                    if (hasNajmaSupplier)
                      _buildChip(
                        text: 'نجمة',
                        backgroundColor: const Color(0xFFE5B537),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String text,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4A4960),
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}