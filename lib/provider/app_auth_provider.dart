import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lalazar_resorts/models/app_user.dart';
import 'package:lalazar_resorts/services/notification_service.dart';
import 'package:lalazar_resorts/services/user_service.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/utils.dart';

class AppAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();
  final _userService = UserService();


  bool _loading = false;
  String _email= '';


  bool get loading => _loading;
  String get email=> _email;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


  AppUser? currentUser;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    final uid = _auth.currentUser!.uid;
    final user = await _userService.getUser(uid);
    if(user!= null)
    {
      currentUser = user;
      Utils().toastSuccess("Login successful");
     _notificationService.listenToBookingStatus(user.uid,user.name);
    }
    else{
      Utils().toastMessage("no  user  found!");
    }
      setLoading(false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } catch (error) {
      if (kDebugMode) print(error.toString());
      Utils().toastMessage(error.toString());
      setLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      Utils().toastMessage('Please enter your email');
      return;
    }
    setLoading(true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils().toastSuccess('Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message ?? 'Error sending reset email');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signup({
    required String name,
    required String address,
    required String gender,
    required String dob,
    required String email,
    required String number,
    required String password,
    required BuildContext context,
  }) async {
    setLoading(true);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      final uid = userCredential.user!.uid;

      final newUser = AppUser(
        uid: uid,
        name: name.trim(),
        number: int.tryParse(number.trim()) ?? 0,
        address: address.trim(),
        gender: Genders.values.firstWhere(
          (e) => e.name.toLowerCase() == gender.trim().toLowerCase(),
          orElse: () => Genders.others,
        ),
        dob: dob.trim(),
        email: email.trim(),
      );

      await _userService.addUser(newUser);

      Utils().toastSuccess("Account created successfully");
      setLoading(false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      Utils().toastMessage(e.message ?? 'Sign up failed');
    } catch (e) {
      setLoading(false);
      Utils().toastMessage(e.toString());
    }
  }

  Future<void> getEmail ()async{
    try{
      final user = _userService.getCurrentUser();
      _userService.getUser(user!.uid);


        _email = user.email!;
      notifyListeners();

    }catch(e){
      Utils().toastMessage('not availaible');
    }

  }
}
