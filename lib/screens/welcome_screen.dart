import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lalazar_resorts/screens/login_screen.dart';
import 'package:lalazar_resorts/screens/signup_screen.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:lalazar_resorts/services/notification_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/h3.jpeg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: mediaquery.screenheight * 0.1),
                    Center(
                      child: Container(
                        height: mediaquery.screenheight*0.2,
                        width: mediaquery.screenwidth*0.45,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/lalazar.jpeg'),
                          fit: BoxFit.cover),
                          border:Border.all(color: Colors.white,width: 3),
                          borderRadius: BorderRadius.circular(10.0)
                        ),

                      ),
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),

                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            height: 60,
                            width: 3,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),

                              ),
                              child: const Text(
                                'Log in',
                                style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
