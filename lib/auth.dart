import 'package:brightstar/otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    super.initState();
  }

  OtpPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpScreen(
                  phone: phoneNo,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.phone,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Mobile No',
                prefixText: '+88 ',
              ),
              onChanged: (val) {
                  setState(() {
                    this.phoneNo = val;
                  });
              },
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                phoneNo.length > 0 ? OtpPage() : null;
              },
              style: TextButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: Colors.blueGrey),
              child: Text(
                "Send OTP",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
