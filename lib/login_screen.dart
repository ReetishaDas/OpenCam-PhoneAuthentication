import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view_videos.dart';
import 'contantsDecoration.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential?.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ViewVideo()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  getMobileFormWidget(context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 25.0,
          ),
          Center(
            child: Container(
              height: 200,
              width: 200,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Hero(
                  tag: 'images',
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: AssetImage('images/images.png'),
                  ),
                ),
              ),
            ),
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 57.0,
              color: Colors.teal.shade800,
              fontFamily: 'Algreya',
              letterSpacing: 3.0,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('VideoLy'),
              ],
              isRepeatingAnimation: true,
            ),
          ),
          SizedBox(
            height: 22.0,
          ),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.phone,
            controller: phoneController,
            decoration: kTextFieldDecoration.copyWith(
              hintText: "Enter Mobile Number",
            ),
          ),
          SizedBox(
            height: 22.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              padding: EdgeInsets.all(12.0),
            ),
            onPressed: () async {
              setState(() {
                showLoading = true;
              });
              await _auth.verifyPhoneNumber(
                phoneNumber: "+91" + phoneController.text,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  // signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                        verificationFailed.message,
                      ),
                    ),
                  );
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text(
              "Get OTP",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Algreya',
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ]);
  }

  getOTPFormWidget(context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('images/images.png'),
            ),
          ),
          SizedBox(
            height: 18.0,
          ),
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: otpController,
            decoration: kTextFieldDecoration.copyWith(
              hintText: "Enter OTP",
            ),
          ),
          SizedBox(
            height: 18.0,
          ),
          GestureDetector(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Didn't get OTP? Send OTP again",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              setState(() {
                showLoading = true;
              });
              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  // signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                        verificationFailed.message,
                      ),
                    ),
                  );
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          ElevatedButton(
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text(
              "Get Started",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Algreya',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              padding: EdgeInsets.all(12.0),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => getMobileFormWidget(context)));
            },
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Algreya',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              padding: EdgeInsets.all(12.0),
            ),
          )
        ],
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              child: showLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : currentState ==
                          MobileVerificationState.SHOW_MOBILE_FORM_STATE
                      ? getMobileFormWidget(context)
                      : getOTPFormWidget(context),
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ),
      ),
    );
  }
}
