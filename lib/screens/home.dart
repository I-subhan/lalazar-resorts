import 'package:flutter/material.dart';
import 'package:lalazar_resorts/screens/Home/home_screen.dart';
import 'package:lalazar_resorts/screens/Home/room_screen.dart';
import 'package:lalazar_resorts/screens/Home/service_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;


  DateTime? checkIn;
  DateTime? checkOut;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(
        );
      case 1:
        return ServiceScreen();
      case 2:
        if (checkIn != null && checkOut != null) {
          return RoomScreen(checkIn: checkIn!, checkOut: checkOut!, bookingId: 'bookingID',totalRoomsToSelect:  1,cityId: '',);
        } else {

          return const Center(
            child: Text('Please select check-in and check-out dates first.'),
          );
        }
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[900],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.design_services_outlined), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.bed_outlined), label: 'Rooms'),
        ],
      ),
    );
  }
}
