import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lalazar_resorts/models/app_user.dart';
import 'package:lalazar_resorts/models/booking.dart';
import 'package:lalazar_resorts/services/user_service.dart';
import '../services/booking_service.dart';
import '../utils/utils.dart';

class HomeProvider with ChangeNotifier {

  TextEditingController checkinController = TextEditingController();
  TextEditingController checkoutController = TextEditingController();
  TextEditingController guestController = TextEditingController();


  String userName = '';
  bool loading = true;


  DateTime? checkIn;
  DateTime? checkOut;
  int? selectedRooms;
  int? selectedPersons;


  List<int> roomOptions = [1, 2, 3, 4, 5];
  List<int> personOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];


  Future<void> fetchUsername() async {
    loading = true;
    notifyListeners();
    final UserService _useerService = UserService();

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if(firebaseUser!= null){
        AppUser? user  = await _useerService.getUser(firebaseUser.uid);
        if (user != null) {
          userName = user.name;
        }
      }
    } catch (e) {
      Utils().toastMessage('Error fetching username: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setCheckIn(DateTime date) {
    checkIn = date;
    checkinController.text = DateFormat('dd-MM-yyyy , hh:mm a').format(date);
    notifyListeners();
  }

  void setCheckOut(DateTime date) {
    checkOut = date;
    checkoutController.text = DateFormat('dd-MM-yyyy , hh:mm a').format(date);
    notifyListeners();
  }

  void setSelectedRooms(int value) {
    selectedRooms = value;
    _updateGuestText();
    notifyListeners();
  }

  void setSelectedPersons(int value) {
    selectedPersons = value;
    _updateGuestText();
    notifyListeners();
  }

  void _updateGuestText() {
    guestController.text = '${selectedRooms ?? 1} Room(s), ${selectedPersons ?? 1} Guest(s)';
  }

  Future<String?> saveBooking() async {
    if (checkIn == null || checkOut == null) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Utils().toastMessage('Please log in to continue.');
      return null;
    }

    try {
      final bookingService = BookingService();


      final booking = Booking(

        status: '',
        userId: user.uid,
        checkInDate: checkIn!,
        checkOutDate: checkOut!,
        createdAt: DateTime.now(),
        guests: selectedPersons ?? 1,
        cityId: '',
        paymentMethod: '',
        roomId: [],
        totalAmount: 0,
        advance: 0,
        lastNotified: false,
        hotelId: '',
      );

      final bookingId = await bookingService.addBooking(booking);
      return bookingId;
    } catch (e) {
      Utils().toastMessage('Error saving booking: $e');
      return null;
    }
  }


}
