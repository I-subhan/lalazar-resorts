import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_settings/app_settings.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Request permission (iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppSettings.openAppSettings();
    }

    // Initialize flutter_local_notifications
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Optional: print device token
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');
  }

  // Background message handler
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    showLocalNotification(message);
  }

  // Show local notification
  static void showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // channel id
      'High Importance Notifications',
      importance: Importance.max,
      description: 'This channel is used for important notifications.',
    );

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      Random.secure().nextInt(100000), // unique id
      message.notification?.title ?? 'Title',
      message.notification?.body ?? 'Body',
      notificationDetails,
    );

  }

  // Get device token for sending test notifications
  static Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  bool _notified = false;
  void listenToBookingStatus(String userId,String userName) {
    FirebaseFirestore.instance .collection('bookings')
      .where('userId', isEqualTo: userId) .snapshots()
        .listen((snapshot) { for (var docChange in snapshot.docChanges)
        { if (docChange.type == DocumentChangeType.modified)
  { final data = docChange.doc.data(); if (data == null) continue;
    if (data['status'] == 'confirmed' || data['status'] == 'rejected' && data['lastNotified'] == false && !_notified)

  { _notified = true;

    NotificationService.showLocalNotification( RemoteMessage( notification: RemoteNotification( title: 'Hey $userName ',
    body: data['status'] == 'confirm' ?'Your booking is confirmed' : 'your booking is rejected', ), ), );
    FirebaseFirestore.instance .collection('bookings')
        .doc(docChange.doc.id)
        .update({'lastNotified': true}); } } } }); }

}
