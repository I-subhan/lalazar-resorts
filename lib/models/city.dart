class City{
  final String id;
  final String cityName;
  final List<String> roomCat;




City({
  required this.cityName,
  required this.roomCat,
  required this.id



});
Map<String,dynamic> toMap(){

  return {
    'cityName' : cityName,
    'roomCat' : roomCat,

  };
}
factory City.fromMap(Map<String,dynamic>map ,String id ){
  return City(
    id:  id,
      cityName: map['cityName'] ?? '',
      roomCat: List<String>.from(map['roomCat'] ?? [])
  );


}
}