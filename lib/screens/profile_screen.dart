import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/button.dart';
import 'package:lalazar_resorts/screens/edit_profile.dart';
import 'package:lalazar_resorts/screens/home.dart';
import 'package:lalazar_resorts/provider/profile_provider.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context,listen: false).getUserData();

  }
  @override
  Widget build(BuildContext context) {
    final profileProvider= Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(

        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfile()),
              );
              if (updated == true) {
                profileProvider.getUserData();
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(builder: (context,profileProvider,_){

        if(profileProvider.loading){

          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: profileProvider.imageBase64 != null
                        ? MemoryImage(base64Decode(profileProvider.imageBase64!))
                        : profileProvider.gender.toLowerCase() == 'male'
                        ? const NetworkImage(
                        'https://i.pinimg.com/736x/0b/97/6f/0b976f0a7aa1aa43870e1812eee5a55d.jpg')
                        : profileProvider.gender.toLowerCase() == 'female'
                        ? const NetworkImage(
                        'https://i.pinimg.com/736x/8c/6d/db/8c6ddb5fe6600fcc4b183cb2ee228eb7.jpg')
                        : null,
                    child: (profileProvider.imageBase64 == null && profileProvider.gender.isEmpty)
                        ? const Icon(Icons.person,
                        size: 60, color: Colors.orange)
                        : null,
                  ),
                   SizedBox(height: mediaquery.screenheight*0.030),
                  Text(
                    profileProvider.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                   SizedBox(height: mediaquery.screenheight*0.07),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           SizedBox(height: mediaquery.screenheight*0.0150),
                          _infoRow(Icons.email_outlined, profileProvider.email),
                          const Divider(),
                          _infoRow(Icons.home_outlined, profileProvider.address),
                          const Divider(),
                          _infoRow(Icons.date_range_outlined, profileProvider.dob),
                          const Divider(),
                          _infoRow(Icons.person, profileProvider.name),
                          const Divider(),
                          _infoRow(Icons.phone,
                              profileProvider.number != null ? '${profileProvider.number}' : 'Not provided'),
                          SizedBox(height: mediaquery.screenheight*0.0125),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Button(
                      title: 'Get Started',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      }),
    );
  }
  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
         SizedBox(width: mediaquery.screenwidth*0.0140),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : 'Not provided',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
