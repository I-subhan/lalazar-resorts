
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bookingdelet extends StatefulWidget {
  const Bookingdelet({super.key});

  @override
  State<Bookingdelet> createState() => _BookingdeletState();
}

class _BookingdeletState extends State<Bookingdelet> {


  Future<void> deleteAllBookings() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Get all documents in the bookings collection
    final QuerySnapshot snapshot = await _firestore.collection('bookings').get();

    if (snapshot.docs.isEmpty) {
      print('No bookings to delete.');
      return;
    }

    // Create a batch
    final WriteBatch batch = _firestore.batch();

    // Add each document delete to the batch
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch
    await batch.commit();

    print('Deleted ${snapshot.docs.length} bookings.');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: (){

          deleteAllBookings();


        }, child: Text('delete',style: TextStyle(fontSize: 40),)

        ),
      ),
    );
  }
}
