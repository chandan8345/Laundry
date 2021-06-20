import 'package:brightstar/auth.dart';
import 'package:brightstar/homes.dart';
import 'package:brightstar/otp.dart';
import 'package:brightstar/push.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Push(),
      //Home(),
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
