import 'package:flutter/material.dart';
import 'package:lalazar_resorts/screens/login_screen.dart';
import 'package:lalazar_resorts/component/custom_text_field.dart';
import 'package:lalazar_resorts/utils/validator.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:provider/provider.dart';
import '../component/button.dart';
import 'package:lalazar_resorts/provider/app_auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final dobcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final addcontroller = TextEditingController();
  final gendercontroller = TextEditingController();
  final numcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Container(
                height: mediaquery.screenheight * 0.13,
                width: mediaquery.screenwidth * 0.3,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/lalazar.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.orange.shade700, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: mediaquery.screenheight * 0.025),

              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextField(
                      controller: emailcontroller,
                      hint: 'Enter email',
                      icon: Icons.email_outlined,
                      color: Colors.grey,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "email is  required";
                        }else if (!Validators.isValidEmail(value)){

                          return 'Enter valid email';
                        }
                      },
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),
                    CustomTextField(
                      controller: passwordcontroller,
                      obscure: true,
                      hint: 'Enter password',
                      icon: Icons.lock_open_rounded,
                      color: Colors.grey,
                      validator: (value){
                        if(value == null||value.isEmpty){

                          return 'Enter password';
                        }
                        else if(Validators.isValidPass(value)){

                          return 'password should be atleast 6 charactors';
                        }
                      },
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),
                    CustomTextField(
                      controller: namecontroller,
                      hint: 'Enter Full name',
                      icon: Icons.person,
                      color: Colors.grey,
                        validator: (value){
                          if(value == null||value.isEmpty){

                            return 'Enter full name ';
                          }}
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),
                    CustomTextField(
                      controller: addcontroller,
                      hint: 'Enter your address',
                      icon: Icons.home_outlined,
                      color: Colors.grey,
                        validator: (value){
                          if(value == null||value.isEmpty){

                            return 'Enter your address ';
                          }}
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),
                    CustomTextField(
                      controller: dobcontroller,
                      hint: 'Enter Date of Birth',
                      icon: Icons.date_range_outlined,
                        color: Colors.grey,
                        validator: (value){
                          if(value == null||value.isEmpty){

                            return 'Enter Date of birth ';
                          }}
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),
                    CustomTextField(
                      controller: gendercontroller,
                      hint: 'Gender',
                      icon: Icons.people_alt_outlined,
                      color: Colors.grey,
                        validator: (value){
                          if(value == null||value.isEmpty){

                            return 'Enter your gender ';
                          }}
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),
                    CustomTextField(
                      controller: numcontroller,
                      hint: 'Number',
                      icon: Icons.phone,
                      color: Colors.grey,
                      isNumber: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is  required";
                        }else if (!Validators.isValidPakistaninumber(value)){

                          return 'Enter valid 11-digit number';
                        }
                      },
                    ),
                    SizedBox(height: mediaquery.screenheight * 0.0140),

                    Consumer<AppAuthProvider>(
                      builder: (context, authProvider, child) {
                        return Button(
                          title: 'Sign Up',
                          width: mediaquery.screenwidth * 0.6,
                          loading: authProvider.loading,
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              authProvider.signup(
                                name: namecontroller.text,
                                address: addcontroller.text,
                                gender: gendercontroller.text,
                                dob: dobcontroller.text,
                                email: emailcontroller.text,
                                number: numcontroller.text,
                                password: passwordcontroller.text,
                                context: context,
                              );
                            }
                          },
                        );
                      },
                    ),

                    SizedBox(height: mediaquery.screenheight * 0.005),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(width: mediaquery.screenwidth * 0.007),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: mediaquery.screenheight * 0.0375),
            ],
          ),
        ),
      ),
    );
  }
}
