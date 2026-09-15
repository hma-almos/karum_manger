import 'package:flutter/material.dart';
import 'package:karum_manger/interfaces/product_card.dart';
import 'package:karum_manger/models/accepted.dart';
import 'package:karum_manger/models/order_details.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:karum_manger/service/product_service.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderDetails orderDetails;

  const OrderDetailsScreen({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');

    // Price Calculations
    final int itemCount = orderDetails.products.length;
    final double rawTotal =
        orderDetails.products.fold(0, (sum, item) => sum + item.price);
    final bool hasDiscount = itemCount >= 5;
    final double calculatedDiscounted =
        rawTotal - ((6000 * orderDetails.products.length) * 0.3);
    final double finalPrice = hasDiscount
        ? ((calculatedDiscounted ~/ 1000) * 1000).toDouble()
        : rawTotal;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFEF),
        // --- Top Header Bar ---
        appBar: AppBar(
          backgroundColor: const Color(0xFF535170),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'العرض',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),

        // --- Main Scrollable Content ---
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            children: [
              // Customer Info Fields
              _buildDetailTile(
                text: orderDetails.fullName,
                hint: 'الاسم',
                icon: Icons.person_outline,
              ),
              _buildDetailTile(
                text: orderDetails.primaryPhone,
                hint: 'رقم الهاتف',
                icon: Icons.phone_outlined,
              ),
              _buildDetailTile(
                text: orderDetails.secondaryPhone ?? '',
                hint: 'هاتف اخر في حال فشل الهاتف الاول بالاتصال',
                icon: Icons.phone_outlined,
              ),
              _buildDetailTile(
                text: orderDetails.governorate,
                hint: 'المحافظة',
                icon: Icons.location_on_outlined,
              ),
              _buildDetailTile(
                text: orderDetails.detailedAddress,
                hint: 'العنوان التفصيلي',
                icon: Icons.pin_drop_outlined,
              ),
              _buildDetailTile(
                text: orderDetails.notes ?? '',
                hint: 'اي ملاحظات؟',
                icon: Icons.note_add_outlined,
              ),

              const SizedBox(height: 8),

              // Price & Delivery Summary Box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFF4A4960), width: 1.5),
                ),
                child: Column(
                  children: [
                    // Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'السعر',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (hasDiscount)
                              Text(
                                '${formatter.format(rawTotal)} د.ع',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '${formatter.format(finalPrice)} د.ع',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Delivery Cost row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'التوصيل',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'مجاني',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Estimated Time row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'متى يصل',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'خلال اقل من يومين',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Products Grid ---
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderDetails.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = orderDetails.products[index];
                  // Fixed: Direct widget return
                  return ProductCard(
                    product: product,
                    onCartUpdated: () {},
                  );
                },
              ),
            ],
          ),
        ),

        // --- Fixed Bottom Action Buttons ---
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Cancel Order Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ProductService().rejectOrder(order: orderDetails);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                    label: const Text('إلغاء الطلب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF535170),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Complete Order Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Accepted accepted = Accepted(date: DateTime.now(), price: finalPrice.toInt(), order: orderDetails);
                      ProductService().acceptOrder(accepted: accepted);
                      Navigator.of(context).pop();

                    },
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                    label: const Text('إكمال الطلب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF535170),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to render read-only detail input cards
  Widget _buildDetailTile({
    required String text,
    required String hint,
    required IconData icon,
  }) {
    final bool hasValue = text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFF4A4960), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? text : hint,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: hasValue ? Colors.black : Colors.grey.shade500,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: const Color(0xFF4A4960)),
          ],
        ),
      ),
    );
  }
}