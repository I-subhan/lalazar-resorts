import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/button.dart';
import 'package:lalazar_resorts/provider/app_auth_provider.dart';
import 'package:lalazar_resorts/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../component/mediaquery.dart';

class ThankyouScreen extends StatefulWidget {
  const ThankyouScreen({super.key});

  @override
  State<ThankyouScreen> createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppAuthProvider>(context, listen: false).getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(2, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFE0B2), Color(0xFFF3E5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 110,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Thank You For Selecting \nLalazar Family Resorts As Your Hosts !',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0125),
                    Text(
                      'Your Booking Will Be Confirmed In Next 12 Hours, Once Your Payment Is Verified. ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Consumer<AppAuthProvider>(
                      builder: (context, authprovider, _) {
                        return Text(
                          'You Will Recieve Confirmation on: ${authprovider.email} ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              Button(
                title: 'Ok',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                width: mediaquery.screenwidth * 0.4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
