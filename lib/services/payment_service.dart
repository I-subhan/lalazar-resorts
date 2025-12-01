
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lalazar_resorts/models/payment.dart';

class PaymentService{

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final String _collection = 'payment';


Future<void> addPayment(Payment payment)async {

  await _firestore.collection(_collection).add(payment.toMap());
}


}