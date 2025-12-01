import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lalazar_resorts/models/city.dart';

class  CityService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'city';


  Future <String> addCity(City city) async{

    final docRef = await _firestore.collection(_collection).add(city.toMap());
    return docRef.id;
  }

  Future<City?> getCityById(String cityId) async {
    final doc = await _firestore.collection(_collection).doc(cityId).get();
    if (doc.exists && doc.data() != null) {
      return City.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updateCity(String cityId,Map<String,dynamic> data)async{


    await _firestore.collection(_collection).doc(cityId).update(data);

  }


  Future<void> deleteCity(String cityId)async{

    await _firestore.collection(_collection).doc(cityId).delete();


  }
  Future<Map<String, dynamic>> getAllCities({String? selectedCityId}) async {
    final snapshot = await _firestore.collection(_collection).get();

    List<Map<String, String>> cities = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['cityName'] as String,
      };
    }).toList();

    Map<String, String>? selectedCity;

    if (selectedCityId != null) {
      selectedCity = cities.firstWhere(
            (c) => c['id'] == selectedCityId,
        orElse: () => {},
      );
    }

    return {
      'cities': cities,
      'selectedCity': selectedCity,
    };
  }
}

