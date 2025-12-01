import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lalazar_resorts/provider/app_auth_provider.dart';
import 'package:lalazar_resorts/provider/city_provider.dart';
import 'package:lalazar_resorts/provider/confirm_provider.dart';
import 'package:lalazar_resorts/provider/home_provider.dart';
import 'package:lalazar_resorts/provider/payment_provider.dart';
import 'package:lalazar_resorts/provider/profile_provider.dart';
import 'package:lalazar_resorts/provider/room_provider.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:lalazar_resorts/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lalazar_resorts/services/notification_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await NotificationService.initialize();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => ConfirmProvider()),

      ],
      child: const MyApp(),
    ),
  );
}
NotificationService notificationService = NotificationService();

@pragma('vm:entry point')
Future<void> backgroundHandler(RemoteMessage message)async{

  Firebase.initializeApp();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        mediaquery.init(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green[900],
              foregroundColor: Colors.white,
            ),
            snackBarTheme: SnackBarThemeData(backgroundColor: Colors.orange),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: Colors.green,
            ),
          ),
          home: WelcomeScreen(),
        );
      },
    );
  }
}
