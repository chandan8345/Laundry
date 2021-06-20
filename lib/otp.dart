import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpScreen extends StatefulWidget {
  String phone;
  OtpScreen({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState(this.phone);
}

class _OtpScreenState extends State<OtpScreen> {
  String phone, verificationId;
  _OtpScreenState(this.phone);
  bool isCounter = true;
  final _pinPutController = TextEditingController();
  final CountdownController _timer = new CountdownController();
  final _pinPutFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    verifyPhone();
    super.initState();
  }

  verifyPhone() {
    _auth.verifyPhoneNumber(
        phoneNumber: '+88'+'$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              print("user loged in");
            } else {
              print("user not loged in");
            }
          });
        },
        verificationFailed: (FirebaseException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationID, int resendToken) {
          setState(() {
            this.verificationId = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            this.verificationId = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(235, 236, 237, 1),
    borderRadius: BorderRadius.circular(5.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "We are send verification code to this " +
                        "$phone" +
                        " number. Get this code and input below.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                        letterSpacing: 2),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  PinPut(
                    autofocus: true,
                    eachFieldWidth: 50.0,
                    eachFieldHeight: 50.0,
                    withCursor: true,
                    fieldsCount: 6,
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    onSubmit: (String pin) async {
                      try {
                        await _auth
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: pin))
                            .then((value) {
                          if (value.user != null) {
                            print("Go to Home");
                          } else {
                            print("Not Go Home");
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.scale,
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: isCounter == false
                        ? Countdown(
                            seconds: 60,
                            controller: _timer,
                            build: (BuildContext context, double time) => Text(
                                time.toString() + " s",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blue,
                                    letterSpacing: 0)),
                            interval: Duration(milliseconds: 100),
                            onFinished: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : SizedBox(),
                  ),
                  TextButton(
                    onPressed: () {
                      _timer.pause();
                      //verifyPhone();
                    },
                    style: TextButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: Colors.pink),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )));
  }
}
