import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lalazar_resorts/models/room.dart';
import 'package:lalazar_resorts/utils/utils.dart';

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'rooms';

  Future<void> addRooms(Room room) async {
    await _firestore.collection(_collection).add(room.toMap());
  }

  Future<Room?> getRoomById(String docId) async {
    final doc = await _firestore.collection(_collection).doc(docId).get();

    if (doc.exists && doc.data() != null) {
      return Room.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<Room>> getAllRooms() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Room.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Room>> getRoomsByCityId(String cityId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('cityIds', arrayContains: cityId)
          .get();
      return snapshot.docs
          .map((doc) => Room.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
    return [];
  }

  Future<List<Room>> getRoomsbyCategory(RoomCategory category) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('categoryName', isEqualTo: category.name)
          .get();
    } catch (e) {
      Utils().toastMessage('error loading by category $e');
    }
    return [];
  }

  Future<void> updateRooms(String docId, Room room) async {
    try {
      await _firestore.collection(_collection).doc(docId).update(room.toMap());
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  Future<List<Room>> getRoomsByCityAndCategory(
    String cityId,
    RoomCategory category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('cityIds', arrayContains: cityId)
          .where('categoryName', isEqualTo: category.name)
          .get();
      return snapshot.docs
          .map((doc) => Room.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch rooms for city and category: $e');
    }
  }
}
