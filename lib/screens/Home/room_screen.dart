import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:lalazar_resorts/provider/city_provider.dart';
import 'package:lalazar_resorts/screens/rooms/executive_room.dart';
import 'package:lalazar_resorts/screens/rooms/family_room.dart';
import 'package:lalazar_resorts/screens/rooms/delux_room.dart';
import 'package:lalazar_resorts/screens/rooms/luxury_room.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final String bookingId;
  final int totalRoomsToSelect;
  final String cityId;

  const RoomScreen({
    super.key,
    required this.totalRoomsToSelect,
    required this.checkIn,
    required this.checkOut,
    required this.bookingId,
    required this.cityId,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  String? selectedRoom;

  @override
  void initState() {
    super.initState();
    Provider.of<CityProvider>(
      context,
      listen: false,
    ).fetchAvailableRooms(widget.cityId);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: mediaquery.screenheight* 0.14,
                      width: mediaquery.screenwidth * 0.3,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/lalazar.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.orange.shade700,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Our Rooms',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // Room dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Consumer<CityProvider>(
                    builder: (context, cityProvider, child) {
                      if (cityProvider.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (cityProvider.availableRooms.isEmpty) {
                        return const Center(child: Text("No rooms available"));
                      }
                      return DropdownButton<String>(
                        hint: const Text('Select Room'),
                        isExpanded: true,
                        value: selectedRoom,
                        items: cityProvider.availableRooms.map((room) {
                          return DropdownMenuItem(
                            value: room,
                            child: Text(room),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRoom = value;
                          });
                          navigateToRoom(value);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Room cards
                Consumer<CityProvider>(
                  builder: (context, cityProvider, child) {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: cityProvider.availableRooms.map((room) {
                        String imageUrl = getRoomImage(room);
                        return buildRoomCard(
                          room,
                          imageUrl,
                          mediaquery.screenheight*0.2,
                          mediaquery.screenwidth*0.5,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigate to selected room screen
  void navigateToRoom(String? title) {
    if (title == null) return;

    switch (title) {
      case 'Deluxe Room':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeluxRoom(
              checkIn: widget.checkIn,
              checkOut: widget.checkOut,
              bookingId: widget.bookingId,
              totalRoomsToSelect: widget.totalRoomsToSelect,
              cityId: widget.cityId,
            ),
          ),
        );
        break;
      case 'Luxury Room':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LuxuryRoom(
              checkIn: widget.checkIn,
              checkOut: widget.checkOut,
              bookingId: widget.bookingId,
              totalRoomsToSelect: widget.totalRoomsToSelect,
              cityId: widget.cityId,
            ),
          ),
        );
        break;
      case 'Family Room':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FamilyRoom(
              checkIn: widget.checkIn,
              checkOut: widget.checkOut,
              bookingId: widget.bookingId,
              totalRoomsToSelect: widget.totalRoomsToSelect,
              cityId: widget.cityId,
            ),
          ),
        );
        break;
      case 'Executive Room':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExecutiveRoom(
              checkIn: widget.checkIn,
              checkOut: widget.checkOut,
              bookingId: widget.bookingId,
              totalRoomsToSelect: widget.totalRoomsToSelect,
              cityId: widget.cityId,
            ),
          ),
        );
        break;
    }
  }

  // Get room image based on title
  String getRoomImage(String room) {
    switch (room) {
      case 'Deluxe Room':
        return 'https://lalazarfamilyresort.com/wp-content/uploads/2024/08/WhatsApp-Image-2024-08-03-at-5.47.30-PM.jpeg';
      case 'Luxury Room':
        return 'https://lalazarfamilyresort.com/wp-content/uploads/2024/08/image00026-scaled.jpeg';
      case 'Executive Room':
        return 'https://lalazarfamilyresort.com/wp-content/uploads/2024/08/WhatsApp-Image-2024-08-03-at-5.44.46-PM-2.jpeg';
      case 'Family Room':
        return 'https://lalazarfamilyresort.com/wp-content/uploads/2024/08/image00007-scaled.jpeg';
      default:
        return '';
    }
  }

  // Build a room card
  Widget buildRoomCard(
    String title,
    String imageUrl,
    double width,
    double height,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoom = title;
        });
        navigateToRoom(title);
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
