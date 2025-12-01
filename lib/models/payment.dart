import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus{

  confirmed,rejected,pending
}
class Payment{


final String bookingId;
final DateTime paymentDate;
final String paymentMethod;
final String recieptPath;
final PaymentStatus status;
final double totalAmount;
final double advance;

Payment({

  required this.bookingId,
  required this.advance,
  required this.totalAmount,
  required this.paymentDate,
  required this.paymentMethod,
  required this.recieptPath,
  required this.status,

});


Map<String,dynamic> toMap(){

  return {

    'bookingId' : bookingId,
    'advance' : advance,
    'totalAmount' : totalAmount,
    'paymentMethod' : paymentMethod,
    'recieptPath': recieptPath,
    'status' : status.name,
    'paymentDate': Timestamp.fromDate(paymentDate),
  };
}
factory Payment.fromMap(Map<String,dynamic>map){

  return Payment(bookingId: map['bookingId'],
      advance: map['advance']?? '',
      totalAmount: map['totalAmount'] ?? '',
      paymentDate: (map['paymentDate'] as Timestamp).toDate(),
      paymentMethod: map['paymentMethod']?? '',
      recieptPath: map['recieptPath']?? '',
      status: PaymentStatus.values.firstWhere((e)=> e.name == map['status'],orElse: ()=>PaymentStatus.pending) );



}




}