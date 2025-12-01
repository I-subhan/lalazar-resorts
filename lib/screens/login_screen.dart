import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/button.dart';
import 'package:lalazar_resorts/screens/forgot_password.dart';
import 'package:lalazar_resorts/provider/app_auth_provider.dart';
import 'package:lalazar_resorts/screens/signup_screen.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              height: mediaquery.screenheight * 0.15,
              width: mediaquery.screenheight * 0.16,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/lalazar.jpeg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.orange.shade700, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: mediaquery.screenheight*0.05),

            const Text(
              'Welcome ',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
             SizedBox(height:mediaquery.screenheight*0.006),
            const Text(
              'Login to continue to Lalazar Resorts',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
             SizedBox(height: mediaquery.screenheight*0.045),


            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      prefixIcon:
                      const Icon(Icons.email_outlined, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter Email';
                      return null;
                    },
                  ),
                   SizedBox(height: mediaquery.screenheight*0.025),

                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter Password';
                      return null;
                    },
                  ),
                  SizedBox(height: mediaquery.screenheight*0.005),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.orange, fontSize: 13),
                      ),
                    ),
                  ),
                   SizedBox(height: mediaquery.screenheight*0.05),

                  Consumer<AppAuthProvider>(
                    builder: (context, authProvider, child) {
                      return Button(
                        title: 'Log in',
                        width: mediaquery.screenwidth *0.6,
                        loading: authProvider.loading,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.login(
                              email: emailcontroller.text,
                              password: passwordcontroller.text,
                              context: context,
                            );
                          }
                        },
                      );
                    },
                  ),
                   SizedBox(height: mediaquery.screenheight*0.0125),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style:
                        TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                       SizedBox(width: mediaquery.screenwidth*0.006),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
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
          ],
        ),
      ),
    );
  }
}
