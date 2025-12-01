import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/app_auth_provider.dart';
import '../../component/button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AppAuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                authProvider.loading
                    ? const CircularProgressIndicator()
                    : Button(
                  title: 'Reset Password',
                  onTap: () {
                    final email = _emailController.text.trim();
                    authProvider.forgotPassword(email);
                  },
                  width: double.infinity,
                  height: 50,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
