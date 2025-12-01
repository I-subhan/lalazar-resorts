import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/home_provider.dart';
import '../../component/date_time.dart';
import '../../component/mediaquery.dart';
import '../../utils/utils.dart';
import '../../component/button.dart';
import 'city_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      if (provider.loading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaquery.screenwidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mediaquery.screenheight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: mediaquery.screenheight * 0.13,
                      width: mediaquery.screenheight * 0.13,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/lalazar.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.orange.shade700, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: mediaquery.screenwidth * 0.0125),
                    Text(
                      'Welcome\n${provider.userName}',
                      style: TextStyle(
                        fontSize: mediaquery.screenwidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mediaquery.screenheight * 0.05),
                TextFormField(
                  readOnly: true,
                  controller: provider.checkinController,
                  decoration: InputDecoration(
                    hintText: 'Select Check-In Date & Time',
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onTap: () async {
                    final date = await DateHelper().selectDate(context);
                    if (date != null) provider.setCheckIn(date);
                  },
                ),
                SizedBox(height: mediaquery.screenheight * 0.03),
                TextFormField(
                  readOnly: true,
                  controller: provider.checkoutController,
                  decoration: InputDecoration(
                    hintText: 'Select Check-Out Date & Time',
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onTap: () async {
                    if (provider.checkIn == null) {
                      Utils().toastMessage('Please select Check-In date first');
                      return;
                    }
                    final date = await DateHelper().selectDate(
                      context,
                      firstDate: provider.checkIn,
                    );
                    if (date != null) provider.setCheckOut(date);

                  },
                ),
                SizedBox(height: mediaquery.screenheight * 0.03),
                TextFormField(
                  readOnly: true,
                  controller: provider.guestController,
                  decoration: InputDecoration(
                    hintText: 'Guests',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onTap: () => showGuestBottomSheet(context, provider),
                ),
                const Spacer(),
                Button(
                  title: 'Go',
                  onTap: () async {
                    if (provider.checkinController.text.isEmpty ||
                        provider.checkoutController.text.isEmpty) {
                      Utils().toastMessage('Select Check-In and Check-Out');
                      return;
                    }

                    final bookingId = await provider.saveBooking();
                    if (bookingId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CityScreen(
                            checkIn: provider.checkIn!,
                            checkOut: provider.checkOut!,
                            bookingId: bookingId,
                            totalRoomsToSelect: provider.selectedRooms ?? 1,
                            cityId: '',
                          ),
                        ),
                      );
                      Utils().toastSuccess('Saved Successfully');
                    }
                  },
                  width: mediaquery.screenwidth * 0.5,
                  height: mediaquery.screenheight * 0.06,
                ),
                SizedBox(height: mediaquery.screenheight * 0.04),
              ],
            ),
          ),
        ),
      );
    });
  }

  void showGuestBottomSheet(BuildContext context, HomeProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: mediaquery.screenwidth * 0.2,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Select Rooms & Guests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Rooms',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  value: provider.selectedRooms,
                  items: provider.roomOptions
                      .map((num) => DropdownMenuItem(value: num, child: Text(num.toString())))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) provider.setSelectedRooms(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Guests',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  value: provider.selectedPersons,
                  items: provider.personOptions
                      .map((num) => DropdownMenuItem(value: num, child: Text(num.toString())))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) provider.setSelectedPersons(value);
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Button(
                    title: 'Done',
                    onTap: () => Navigator.pop(context),
                    textColor: Colors.white,
                    width: 150,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
