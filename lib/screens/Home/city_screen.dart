import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lalazar_resorts/provider/city_provider.dart';
import 'package:provider/provider.dart';

import 'room_screen.dart';
import '../../component/button.dart';
import '../../component/mediaquery.dart';
import '../../utils/utils.dart';

class CityScreen extends StatefulWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final String bookingId;
  final int totalRoomsToSelect;
  final String cityId;

  const CityScreen({
    super.key,
    required this.bookingId,
    required this.totalRoomsToSelect,
    required this.checkOut,
    required this.checkIn,
    required this.cityId,
  });

  @override
  State createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {

  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CityProvider>(context,listen:  false).fetchCities();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CityProvider>(builder: (context,cityProvider,child){

        if(cityProvider.loading)
        {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height:mediaquery.screenheight* 0.15,
                    width: mediaquery.screenwidth * 0.35,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/lalazar.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                          color: Colors.orange.shade700, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: mediaquery.screenheight * 0.09),
                  const Text(
                    'Choose your destination city',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  SizedBox( height: mediaquery.screenheight * 0.01),
                  TypeAheadField<Map<String, String>>(
                    suggestionsCallback: (pattern) {
                      return cityProvider.cities
                          .where((city) =>
                          city['name']!.toLowerCase().contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(title: Text(suggestion['name']!));
                    },
                    onSelected: (suggestion) {
                      cityProvider.selectCity(suggestion['name']!, suggestion['id']!);
                      _cityController.text = suggestion['name']!;
                    },
                    builder: (context, suggestion, focusNode) {
                      return TextField(
                        controller: _cityController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Search or select city',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: mediaquery.screenheight * 0.3),
                  Button(
                    title: 'Continue',
                    onTap: () async {
                      if (cityProvider.selectedCity == null ||
                          cityProvider.selectedCity!.isEmpty ||
                          cityProvider.selectedCityId == null) {
                        Utils().toastMessage('Please select a city first');
                        return;
                      }

                      await cityProvider.updateBooking(widget.bookingId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomScreen(
                            totalRoomsToSelect:
                            widget.totalRoomsToSelect,
                            checkIn: widget.checkIn,
                            checkOut: widget.checkOut,
                            bookingId: widget.bookingId,
                            cityId: cityProvider.selectedCityId!,
                          ),
                        ),
                      );
                    },
                    width:mediaquery.screenwidth * 0.5,
                  ),
                ],
              ),
            ),
          ),
        );

      })



    );
  }
}
