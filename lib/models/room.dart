

import 'package:cloud_firestore/cloud_firestore.dart';

enum RoomCategory{

  Deluxe,Executive,Luxury,Family
}

class Room{
final String roomId;
final List<String> cityIds;
final String imageUrl;
final double price;
final RoomCategory categoryName;

Room({

  required this.roomId,
  required this.imageUrl,
  required this.price,
  required this.cityIds,
  required this.categoryName,
});


Map<String,dynamic> toMap(){

  return {
     'roomId' : roomId,
    'imageUrl' : imageUrl,
    'price' : price,
    'cityId' : cityIds,
    'categoryName' : categoryName.name,
  };

}

factory Room.fromMap(Map<String,dynamic>map, String docId){

  return Room(
    roomId: docId,
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      cityIds: List<String>.from(map['cityId'] ?? []),
      categoryName: RoomCategory.values.firstWhere((e)=>e.name == map['categoryName'],
      orElse: ()=> RoomCategory.Deluxe,)

  );
}

}