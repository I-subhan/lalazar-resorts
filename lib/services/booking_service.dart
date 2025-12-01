
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lalazar_resorts/models/booking.dart';

class BookingService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';



  Future<String> addBooking(Booking booking) async {
    final docRef = await _firestore.collection(_collection).add(booking.toMap());
    return docRef.id;
  }


  Future<List<Booking>> getBookingsByUser(String userId) async{

    final snapshot = await _firestore .collection(_collection).
    where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc)=> Booking.fromMap(doc.data())).toList();
}


Future<Booking?> getBookingById(String bookingId,)async{


    final doc = await _firestore.collection(_collection).doc(bookingId).get();
    if(!doc.exists) return null;
    return Booking.fromMap(doc.data()!);

}
Future<void> updateBooking(String bookingId, Map<String,dynamic> data) async
{

  await _firestore.collection(_collection).doc(bookingId).update(data);
}
Future<void> deleteBooking(String bookingId) async {

    await _firestore.collection(_collection).doc(bookingId).delete();



}

  Future<List<Booking>> getBookingsByCity(String cityId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('cityId', isEqualTo: cityId)
        .get();

    return snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList();
  }




}