import 'package:flutter/material.dart';
import 'package:karum_manger/interfaces/analysis_screen.dart';
import 'package:karum_manger/interfaces/custom_bottom_nav_bar.dart';
import 'package:karum_manger/interfaces/orders_list_body.dart';
import 'package:karum_manger/models/accepted.dart';
import 'package:karum_manger/models/order_details.dart';
import 'package:karum_manger/service/product_service.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  bool _isLoading = true;

  // Removed 'static' keywords so data stays scoped to this state instance
  List<OrderDetails> _orders = [];
  List<Accepted> _accepted = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fetchedOrders = await ProductService().getAllOrders();
    // Uncomment when you're ready:
    // final fetchedAccepted = await ProductService().getAllAccepted();

    if (mounted) {
      setState(() {
        _orders = fetchedOrders;
        // _accepted = fetchedAccepted;
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildPages() {
    return [
      OrdersListBody(orders: _orders),
      AnalyticsView(acceptedOrders: _accepted),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF535170),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
              child: Image.asset("assets/logo.png"),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF535170),
                ),
              )
            : IndexedStack(
                index: _currentIndex,
                children: _buildPages(),
              ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}