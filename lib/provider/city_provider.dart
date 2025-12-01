import 'package:flutter/material.dart';
import 'package:lalazar_resorts/services/booking_service.dart';
import 'package:lalazar_resorts/services/city_service.dart';

import '../utils/utils.dart';



class CityProvider with ChangeNotifier{

  final BookingService _bookingService = BookingService();
  final CityService _cityService = CityService();

  List<Map<String, String>> _cities = [];
  List<String> _availableRooms = [];
  bool _loading = false;
  String? _selectedCity;
  String? _selectedCityId;



  bool get loading=> _loading;
  String? get selectedCity=> _selectedCity;
  String? get selectedCityId => _selectedCityId;
  List<Map<String, String>> get cities=> _cities;
  List<String> get availableRooms=> _availableRooms;


  void setLoading(bool value){

    _loading = value;
    notifyListeners();
  }


  Future<void> fetchCities({String? cityId}) async {
    setLoading(true);
    try {
      final data = await _cityService.getAllCities(selectedCityId: cityId);

      _cities = List<Map<String, String>>.from(data['cities']);
      if (data['selectedCity'] != null && (data['selectedCity'] as Map).isNotEmpty) {
        _selectedCityId = data['selectedCity']['id'];
        _selectedCity = data['selectedCity']['name'];
      }

      notifyListeners();
    } catch (e) {
      Utils().toastMessage("Error fetching cities: $e");
    } finally {
      setLoading(false);
    }
  }

  void selectCity(String cityName,String cityId){

    _selectedCity = cityName;
    _selectedCityId = cityId;
    notifyListeners();
  }
  Future<void>updateBooking(String bookingId)async{

    if(_selectedCity == null ) return ;

    try{

      _bookingService.updateBooking(bookingId, {
        'cityId' : selectedCityId
      });


    }catch(e){Utils().toastMessage("Booking update error: $e");}


  }
  Future<void> fetchAvailableRooms(String cityId) async {
    setLoading(true);
    try {
      final city = await _cityService.getCityById(cityId);
      if (city != null) {

        if (city.roomCat != null && city.roomCat.isNotEmpty) {

            _availableRooms = city.roomCat.map((e) => e.toString()).toList();

        } else {

            _availableRooms = [];
            notifyListeners();

        }
      } else {

          _availableRooms = [];
          notifyListeners();

      }
    } catch (e) {
      print('Error fetching rooms: $e');

        _availableRooms = [];

    }finally{
      setLoading(false);
      notifyListeners();
    }
  }



}