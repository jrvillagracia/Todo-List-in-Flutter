import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:intellidoflutter/widgets/auth_screen.dart';
import 'package:intellidoflutter/widgets/login_widget.dart';
import 'package:intellidoflutter/widgets/signup_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCXAh_lXL7bxg_QfqzkYavUEQIEmVhQGZM",
            authDomain: "intellido--flutter-version.firebaseapp.com",
            projectId: "intellido--flutter-version",
            storageBucket: "intellido--flutter-version.appspot.com",
            messagingSenderId: "885967776843",
            appId: "1:885967776843:web:b8e244867bf53d0c30b1ce",
            measurementId: "G-JFK27W2SK2"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntelliDo!',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/white.png'),
              Container(
                margin: EdgeInsets.only(bottom: 32.0),

              ),

              Container(

                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = false;
                        });
                      },

                      child: Column(
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: isLogin ? Colors.grey : Colors.black,
                            ),
                          ),

                          if (!isLogin)
                            Container(
                              height: 2,
                              width: 75,
                              color: Colors.black,
                            ),
                        ],
                      ),
                    ),

                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = true;
                        });
                      },

                      child: Column(
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: isLogin ? Colors.black : Colors.grey,
                            ),
                          ),
                          if (isLogin)
                            Container(
                              height: 2,
                              width: 75,
                              color: Colors.black,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              isLogin
                  ? LoginWidget(onClickedSignUp: toggle)
                  : SignUpWidget(onClickedSignIn: toggle),
            ],
          ),
        ),
      ),
    );
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
