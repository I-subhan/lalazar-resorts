import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/button.dart';
import 'package:lalazar_resorts/provider/profile_provider.dart';
import 'package:lalazar_resorts/component/custom_text_field.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:provider/provider.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final numController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    provider.getUserData().then((_) {
      nameController.text = provider.name;
      emailController.text = provider.email;
      dobController.text = provider.dob;
      genderController.text = provider.gender;
      addressController.text = provider.address;
      numController.text = provider.number?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: mediaquery.screenheight * 0.025),

                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return GestureDetector(
                      onTap: profileProvider.pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: profileProvider.imageFile != null
                                ? FileImage(profileProvider.imageFile!)
                                : (profileProvider.imageBase64 != null
                                      ? MemoryImage(
                                          base64Decode(
                                            profileProvider.imageBase64!,
                                          ),
                                        )
                                      : NetworkImage(
                                              genderController.text
                                                          .toLowerCase() ==
                                                      'male'
                                                  ? 'https://i.pinimg.com/736x/0b/97/6f/0b976f0a7aa1aa43870e1812eee5a55d.jpg'
                                                  : genderController.text
                                                            .toLowerCase() ==
                                                        'female'
                                                  ? 'https://i.pinimg.com/736x/8c/6d/db/8c6ddb5fe6600fcc4b183cb2ee228eb7.jpg'
                                                  : 'https://via.placeholder.com/150',
                                            )
                                            as ImageProvider),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: mediaquery.screenheight * 0.0375),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        hint: 'Name',
                        icon: Icons.abc_outlined,
                      ),
                      SizedBox(height: mediaquery.screenheight * 0.0150),
                      CustomTextField(
                        controller: emailController,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(height: mediaquery.screenheight * 0.0150),
                      CustomTextField(
                        controller: addressController,
                        hint: 'Address',
                        icon: Icons.home_outlined,
                      ),
                      SizedBox(height: mediaquery.screenheight * 0.0150),
                      CustomTextField(
                        controller: dobController,
                        hint: 'DOB',
                        icon: Icons.person,
                      ),
                      SizedBox(height: mediaquery.screenheight * 0.0150),
                      CustomTextField(
                        controller: numController,
                        hint: 'Number',
                        icon: Icons.phone,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mediaquery.screenheight * 0.05),
                Consumer<ProfileProvider>(
                  builder: (context, provider, _) {
                    return Button(
                      title: 'Save Changes',
                      onTap: () async {
                        await provider.updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          gender: genderController.text,
                          dob: dobController.text,
                          number: numController.text,
                          address: addressController.text,
                        );
                        Navigator.pop(context, true);
                      },
                    );
                  },
                ),
                SizedBox(height: mediaquery.screenheight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
