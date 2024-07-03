import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intellidoflutter/pages/HomePage.dart';
import 'package:intellidoflutter/widgets/ForgotPassword.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;
  int loginAttempts = 0;
  final int maxLoginAttempts = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Enter your Email'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Enter your Password',
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            obscureText: _obscureText,
          ),
          SizedBox(height: 20),
          if (errorMessage != null)
            Text(
              errorMessage!,
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
                    onPressed: loginAttempts >= maxLoginAttempts ? null : signIn,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
          SizedBox(height: 20),
          TextButton(
            onPressed: widget.onClickedSignUp,
            child: Text('Don\'t have an account? Sign Up'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(),
            )),
            child: Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please fill out all fields';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigate to main app screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Please check your credentials and try again';
        loginAttempts++;
        if (loginAttempts >= maxLoginAttempts) {
          errorMessage = 'Too many login attempts. Please try again later.';
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
