// import 'package:flutter/material.dart';
// import 'package:intellidoflutter/widgets/signup_widget.dart';
// import 'package:intellidoflutter/widgets/login_widget.dart';

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   bool isLogin = true;

//   void toggle() => setState(() => isLogin = !isLogin);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: isLogin ? LoginWidget(onClickedSignUp: toggle) : SignUpWidget(onClickedSignIn: toggle),
//       ),
//     );
//   }
// }