import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:lalazar_resorts/services/user_service.dart';
import 'package:provider/provider.dart';
import '../../models/room.dart';
import '../../provider/room_provider.dart';
import '../../component/button.dart';
import '../../utils/utils.dart';
import 'confirm_screen.dart';

class FamilyRoom extends StatefulWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final String bookingId;
  final int totalRoomsToSelect;
  final String cityId;

  const FamilyRoom({
    super.key,
    required this.cityId,
    required this.totalRoomsToSelect,
    required this.checkIn,
    required this.checkOut,
    required this.bookingId,
  });

  @override
  State<FamilyRoom> createState() => _FamilyRoomState();
}

class _FamilyRoomState extends State<FamilyRoom> {
  final user = UserService().getCurrentUser();
  int selectedCount = 0;

  @override
  void initState() {
    super.initState();
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    roomProvider.fetchRooms(
      cityId: widget.cityId,
      category: RoomCategory.Executive,
      checkIn: widget.checkIn,
      checkOut: widget.checkOut,
    );

    roomProvider.fetchUserName(user!.uid);

    roomProvider.scheduleEmptyBookingDeletion(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Family Room Gallery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<RoomProvider>(
        builder: (context, roomProvider, child) {
          if (roomProvider.loading)
            return const Center(child: CircularProgressIndicator());

          if (roomProvider.availableRooms.isEmpty) {
            return Center(child: Text('No rooms available'));
          }
          return buildRoomGallery();
        },
      ),
    );
  }

  Widget buildRoomGallery() {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: mediaquery.screenheight * 0.15,
            width: mediaquery.screenwidth * 0.35,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/lalazar.jpeg'),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.orange.shade700, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 25),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Available Rooms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 15),

          Consumer<RoomProvider>(
            builder: (context, roomProvider, child) {
              return Column(
                children: roomProvider.availableRooms.map((room) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            room.imageUrl,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                'Family Room',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Button(
                                title: 'Select Room',
                                onTap: () => roomProvider
                                    .bookRoom(
                                      roomId: room.roomId,
                                      bookingId: widget.bookingId,
                                      userId: user!.uid,
                                      totalRoomsToSelect:
                                          widget.totalRoomsToSelect,
                                      onComplete: () {},
                                    )
                                    .then((result) {
                                      if (result == 'already_selected') {
                                        Utils().toastMessage(
                                          'You already selected this room',
                                        );
                                      } else if (result == 'completed') {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ConfirmScreen(
                                              totalRoomsToSelect:
                                                  widget.totalRoomsToSelect,
                                              bookingId: widget.bookingId,
                                            ),
                                          ),
                                        );
                                      } else if (result == 'not_enough') {
                                        Utils().toastMessage(
                                          'Not enough rooms. Please choose from another category.',
                                        );
                                      } else if (result == 'continue') {
                                        Utils().toastSuccess(
                                          'Room selected. Please select ${widget.totalRoomsToSelect - roomProvider.selectedCount} more.',
                                        );
                                      } else {
                                        Utils().toastMessage(result);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
