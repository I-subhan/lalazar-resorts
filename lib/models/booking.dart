import 'package:cloud_firestore/cloud_firestore.dart';



class Booking{


  final String userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final DateTime createdAt;
  final String cityId;
  final String paymentMethod;
  final List<String> roomId;
  final String status;
  final double advance;
  final double totalAmount;
  final String hotelId;
  bool lastNotified;




  Booking({

    required this.status,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.createdAt,
    required this.guests,
    required this.cityId,
    required this.paymentMethod,
    required this.roomId,
    required this.totalAmount,
    required this.advance,
    required this.hotelId,
    this.lastNotified = false,

});

Map<String,dynamic> toMap(){

  return {

    'status':status,
    'checkInDate': Timestamp.fromDate(checkInDate),
    'checkOutDate':Timestamp.fromDate(checkOutDate),
    'createdAt': Timestamp.fromDate(createdAt),
    'guests' : guests,
    'cityId' : cityId,
    'paymentMethod': paymentMethod,
    'roomId': roomId,
    'totalAmount':totalAmount,
    'hotelId':  hotelId,
    'advance' : advance,
    'userId' : userId,
    'lastNotified': lastNotified,

  };
}
factory Booking.fromMap(Map<String,dynamic>map){
  return Booking(

    status: map['status'] ?? '',
      userId: map['userId'] ?? '',
      checkInDate:(map['checkInDate'] as Timestamp).toDate() ,
      checkOutDate: (map['checkOutDate'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      guests: map['guests'] ?? 1,
      cityId: map['cityId'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      roomId: List<String>.from(map['roomId']?? []),
      totalAmount: map['totalAmount'],
      advance: map['advance'],
      lastNotified: map['lastNotified'] ?? false,
      hotelId: map['hotelId']);
}
}