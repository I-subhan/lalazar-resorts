import 'package:flutter/cupertino.dart';
import 'package:lalazar_resorts/services/booking_service.dart';
import 'package:lalazar_resorts/services/room_service.dart';
import '../models/app_user.dart';
import '../services/user_service.dart';
import '../utils/utils.dart';

class ConfirmProvider with ChangeNotifier {
  final _userService = UserService();
  final _bookingService = BookingService();
  final _roomService = RoomService();

  String _name = '';
  String _number = '';
  double _totalAmount = 0.0;
  double _advance = 0.0;

  String get name => _name;
  String get number => _number;
  double get totalAmount => _totalAmount;
  double get advance => _advance;

  Future<void> getuser() async {
    try {
      final firebaseUser = UserService().getCurrentUser();
      if (firebaseUser != null) {
        AppUser? user = await _userService.getUser(firebaseUser!.uid);

        if (user != null) {
          _name = user.name;
          _number = user.number.toString();

          notifyListeners();
        }
      }
    } catch (e) {
      Utils().toastMessage('Error loading');
    }
  }

  Future<void> getTotalAmount(String bookingId) async {
    try {
      final booking = await _bookingService.getBookingById(bookingId);

      if (booking == null) {
        Utils().toastMessage("Booking not found");
        return;
      }

      final List<String> roomIds = List<String>.from(booking.roomId);

      double sum = 0.0;

      for (String roomId in roomIds) {
        final room = await _roomService.getRoomById(roomId);

        if (room != null && room.price != null) {
          sum += room.price.toDouble();
        }
      }

      _totalAmount = sum;
      _advance = sum * 0.4;
      notifyListeners();
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }
}
