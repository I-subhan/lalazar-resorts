import 'dart:convert' show base64Encode;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lalazar_resorts/models/app_user.dart';
import 'package:lalazar_resorts/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

class ProfileProvider with ChangeNotifier {
  final _userService = UserService();
  AppUser? currentUser;


  bool _loading = false;
  String? _imageBase64;
  File? _imageFile;


  String? get imageBase64 => _imageBase64;
  bool get loading => _loading;
  String get name => currentUser?.name ?? '';
  String get email => currentUser?.email ?? '';
  String get address => currentUser?.address ?? '';
  String get dob => currentUser?.dob ?? '';
  String get gender => currentUser?.gender.name ?? '';
  int? get number => currentUser?.number;
  File? get imageFile => _imageFile;



  void setLoading(bool value){

    _loading = value;
    notifyListeners();
  }

  Future<void> getUserData() async {
    setLoading(true);

    try {
      final user = _userService.getCurrentUser();
      if (user == null) return;

        final prefs = await SharedPreferences.getInstance();
        _imageBase64 = prefs.getString('profile_image_${user.uid}');


        final appUser = await _userService.getUser(user.uid);

        if (appUser != null) {
          currentUser = appUser;
        }else{

          Utils().toastMessage('user not found');
        }
      notifyListeners();
    } catch (e) {
      Utils().toastMessage('Error loading data: $e');
    } finally {
     setLoading(false);
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        Utils().toastMessage('No image selected.');
        return;
      }
      final file = File(pickedFile.path);
      await saveImage(file);

      Utils().toastSuccess('Profile image updated successfully!');
    } catch (e) {
      Utils().toastMessage('Error: $e');
    }
  }
  Future<void> saveImage(File image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);

    final prefs = await SharedPreferences.getInstance();
    final user = _userService.getCurrentUser();
    if (user != null) {
      await prefs.setString('profile_image_${user.uid}', base64String);
    }



      _imageBase64 = base64String;
      _imageFile = image;

      notifyListeners();
  }






  Future<void> updateUserData({
    required String name,
    required String email,
    required String address,
    required String dob,
    required String gender,
    required String number,
  }) async {
    setLoading(true);
    try {
      final user = _userService.getCurrentUser();
      if (user == null) return;

      final updatedUser = AppUser(
          uid: user.uid,
          name: name.trim(),
          number: int.tryParse(number.trim()) ?? 0,
          address: address.trim(),
          gender: Genders.values.firstWhere((e)=>e.name.toLowerCase() == gender.trim()),
          dob: dob.trim(),
          email: email.trim());


  await _userService.updateUser(updatedUser);
  currentUser = updatedUser;
      Utils().toastSuccess('Profile updated successfully!');
    } catch (e) {
      Utils().toastMessage('Update failed: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
