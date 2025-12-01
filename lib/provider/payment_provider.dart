import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lalazar_resorts/models/payment.dart';
import 'package:lalazar_resorts/services/booking_service.dart';
import 'package:lalazar_resorts/services/payment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/rooms/thankyou_screen.dart';
import '../utils/utils.dart';




class PaymentProvider with ChangeNotifier{

  File? _receiptImage;
  bool _loading = false;
  String? _selectedMethod;


  final PaymentService _paymentService = PaymentService();
  final BookingService _bookingService = BookingService();


  File? get receiptImage=> _receiptImage;
  String? get selectedMethod =>_selectedMethod;
  bool get loading => _loading;


  void setLoading(value){

    _loading = value;
    notifyListeners();

  }
  void selected(String method){

    _selectedMethod = method;
    notifyListeners();

  }


  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
       _receiptImage = File(picked.path);
       notifyListeners();
    }
  }

  Future<bool> uploadReceipt({
    required String bookingId,
    required double totalAmount,
    required double advance,

} ) async {
    if (_receiptImage == null || _selectedMethod == null) {
      Utils().toastMessage('Please select payment method and upload receipt');
      return false;
    }

    try {
      setLoading(true);

      // Save receipt locally using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('receipt_path', _receiptImage!.path);
      await prefs.setString('selected_method', _selectedMethod!);
      await prefs.setString('booking_id', bookingId);



      //  Save payment info in Firestore
      final payment = Payment(
          bookingId: bookingId,
          advance: advance,
          totalAmount: totalAmount,
          paymentDate: DateTime.now(),
          paymentMethod: _selectedMethod!,
          recieptPath: _receiptImage!.path,
          status: PaymentStatus.pending,

      );
      await _paymentService.addPayment(payment);




      await _bookingService.updateBooking(bookingId, {

        'paymentMethod' : _selectedMethod,
        'totalAmount' : totalAmount,
        'advance' : advance,
        'status': 'pending',




      });

      Utils().toastSuccess('Payment details saved successfully!');
      return true;


    } catch (e) {
      Utils().toastMessage('Error saving payment: $e');
      return false;
    } finally {
      setLoading(false);
    }

  }
}