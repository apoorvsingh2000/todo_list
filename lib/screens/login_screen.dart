import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/screens/tasks_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_STATE,
  SHOW_OTP_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : currentState == MobileVerificationState.SHOW_MOBILE_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
    );
  }

  getMobileFormWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              'To-do List',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 50.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  hintText: "Enter phone number", fillColor: Colors.grey),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  showLoading = true;
                });
                await _auth.verifyPhoneNumber(
                  phoneNumber: '+91' + phoneController.text,
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      showLoading = false;
                    });
                    //signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  verificationFailed: (verificationFailed) async {
                    setState(() {
                      showLoading = false;
                    });
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(verificationFailed.message),
                      ),
                    );
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      showLoading = false;
                      currentState = MobileVerificationState.SHOW_OTP_STATE;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              },
              child: Text(
                'VERIFY',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  getOtpFormWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              'To-do List',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 50.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            TextField(
              controller: otpController,
              decoration:
                  InputDecoration(hintText: "Enter OTP", fillColor: Colors.grey),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: otpController.text);
                signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              child: Text(
                'VERIFY',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showLoading = false;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
    //
  }
}
