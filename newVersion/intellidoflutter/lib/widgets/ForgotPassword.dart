import 'package:flutter/material.dart';
import 'package:intellidoflutter/widgets/forgotpassword_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();
  String? message;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to send you a password reset email',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Enter your Email'),
            ),
            SizedBox(height: 20),
            if (message != null)
              Text(
                message!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromARGB(255, 76, 0, 253),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: sendPasswordResetEmail,
                      child: Text(
                        'Send Email',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        message = 'Please enter your email';
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      await _forgotPasswordService.sendPasswordResetEmail(email);
      setState(() {
        message = 'Password reset email sent';
      });
    } catch (e) {
      setState(() {
        message = 'Error sending password reset email';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
