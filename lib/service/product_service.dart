import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karum_manger/models/accepted.dart';
import 'package:karum_manger/models/order_details.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // 1. Get all orders from orders collection
  // ProductService
  Future<List<OrderDetails>> getAllOrders() async {
    final snapshot = await _firestore.collection('orders').get();
    return snapshot.docs
    
        .map((doc) => OrderDetails.fromMap(doc.data(),doc.id))
        .toList();
  }
    Future<List<Accepted>> getAllAccepted() async {
    final snapshot = await _firestore.collection('accepted').get();
    return snapshot.docs
        .map((doc) => Accepted.fromMap(doc.data(),"xxxxx"))
        .toList();
  }

  // 2. Post Accepted model to accepted collection & delete order from orders collection
  Future<void> acceptOrder({
    required Accepted accepted,
  }) async {
    final batch = _firestore.batch();

    final acceptedRef = _firestore.collection('accepted').doc();
    batch.set(acceptedRef, accepted.toMap());

    final orderRef = _firestore.collection('orders').doc(accepted.order.id);
    batch.delete(orderRef);

    await batch.commit();
  }

  // 3. Post rejected order to rejected collection & delete order from orders collection
  Future<void> rejectOrder({
    required OrderDetails order,
  }) async {
    final batch = _firestore.batch();

    final rejectedRef = _firestore.collection('rejected').doc();
    batch.set(rejectedRef, {
      'rejectedAt': DateTime.now().toIso8601String(),
      'order': order.toMap(),
    });
    final orderRef = _firestore.collection('orders').doc(order.id);
    batch.delete(orderRef);
    await batch.commit();
  }
}