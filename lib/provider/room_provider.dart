import 'package:flutter/material.dart';
import 'package:lalazar_resorts/services/booking_service.dart';
import 'package:lalazar_resorts/services/room_service.dart';
import 'package:lalazar_resorts/services/user_service.dart';
import '../models/room.dart';
import '../utils/utils.dart';

class RoomProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();
  final BookingService _bookingService = BookingService();
  final UserService _userService = UserService();


  bool loading = false;
  List<Room> availableRooms = [];
  int selectedCount = 0;
  String? userName;

  Future<void> fetchRooms({
    required String cityId,
    required RoomCategory category,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    try {
      loading = true;
      notifyListeners();

      // Room service to fetch rooms
      final rooms = await _roomService.getRoomsByCityAndCategory(cityId, category);

      if (rooms.isEmpty) {
        availableRooms = [];
        loading = false;
        notifyListeners();
        Utils().toastMessage('No rooms found for this category in this city.');
        return;
      }

      // Convert rooms to doc-like list
      final allRooms = rooms;

      // Fetch all bookings
      // Fetch bookings for the city via BookingService
      final bookings = await _bookingService.getBookingsByCity(cityId);
      final Set<String> bookedRoomIds = {};

      for (var booking in bookings) {
        if (booking.roomId == null || booking.checkInDate == null || booking.checkOutDate == null) continue;

        final bookedIn = booking.checkInDate!;
        final bookedOut = booking.checkOutDate!;

        final overlaps = !(checkOut.isBefore(bookedIn) || checkIn.isAfter(bookedOut)) &&
            (checkOut.isAfter(bookedIn) || checkOut.isAtSameMomentAs(bookedIn));

        if (overlaps) {
          if (booking.roomId is List) {
            bookedRoomIds.addAll((booking.roomId as List).map((e) => e.toString().trim()));
          } else if (booking.roomId is String) {
            bookedRoomIds.add((booking.roomId as String).trim());
          }
        }
      }

      // Filter available rooms
      availableRooms = allRooms.where((room) {
        return !bookedRoomIds.contains(room.roomId.trim());
      }).toList();

      loading = false;
      notifyListeners();

      if (availableRooms.isEmpty) {
        Utils().toastMessage('No rooms available for selected dates in this city.');
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      Utils().toastMessage('Error loading rooms: $e');
    }
  }

  // Book a room
  Future<String> bookRoom({
    required String roomId,
    required String bookingId,
    required String userId,
    required int totalRoomsToSelect,
    required VoidCallback onComplete,
  }) async {
    try {
      final booking = await _bookingService.getBookingById(bookingId);
      if (booking == null) return 'error: Booking not found';

      List<dynamic> currentRooms = booking.roomId ?? [];
      if (currentRooms.contains(roomId)) return 'already_selected';

      currentRooms.add(roomId);
      await _bookingService.updateBooking(bookingId, {
        'roomId': currentRooms,
        'userId': userId,

      });

      selectedCount = currentRooms.length;
      availableRooms.removeWhere((room) => room.roomId == roomId);
      notifyListeners();

      if (selectedCount >= totalRoomsToSelect) return 'completed';
      else if (availableRooms.isEmpty) return 'not_enough';
      else return 'continue';

    } catch (e) {
      return 'error: $e';
    }
  }

  Future<void> deleteEmptyBooking(String bookingId) async {
    try {
      final booking = await _bookingService.getBookingById(bookingId);

      if (booking == null) {
        print('Booking not found');
        return;
      }

      final roomId = booking.roomId;

      bool isEmptyBooking = false;

      if (roomId == null) {
        isEmptyBooking = true;
      } else if (roomId is String && (roomId as String).trim().isEmpty) {
        isEmptyBooking = true;
      } else if (roomId is List && roomId.isEmpty) {
        isEmptyBooking = true;
      }

      if (isEmptyBooking) {
        await _bookingService.deleteBooking(bookingId);
        print('Deleted empty booking: $bookingId');
      } else {
        print('Booking has a room assigned, not deleting.');
      }
    } catch (e) {
      print('Error deleting empty booking: $e');
    }
  }



  //  schedule deletion after delay
  Future<void> scheduleEmptyBookingDeletion(String bookingId) async {
    await Future.delayed(Duration(seconds: 30));
    await deleteEmptyBooking(bookingId);
  }



  Future<void> fetchUserName(String userId) async {
    try {
      final user = await _userService.getUser(userId);

      if(user !=null){
        userName = user.name;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }






}
