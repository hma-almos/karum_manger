import 'package:flutter/material.dart';
import 'package:karum_manger/interfaces/order_card_widget.dart';
import 'package:karum_manger/models/order_details.dart';

class OrdersListBody extends StatelessWidget {
  final List<OrderDetails> orders;
  final Function(OrderDetails order)? onOrderTap;
  final Future<void> Function()? onRefresh;

   const OrdersListBody({
    Key? key,
    required this.orders,
    this.onOrderTap,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Background color matching the light grey design area
    return Container(
      color: const Color(0xFFEFEFEF),
      child: orders.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCardWidget(orderDetails: order,);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'لا توجد طلبات حالياً',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
}