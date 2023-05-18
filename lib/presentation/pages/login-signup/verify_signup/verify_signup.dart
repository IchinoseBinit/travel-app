import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_button.dart';
import 'package:travel_app/presentation/pages/login-signup/login/login_screen.dart';
import 'package:travel_app/presentation/pages/login-signup/signup/components/background.dart';
import 'package:travel_app/presentation/pages/login-signup/signup/signup_screen.dart';
import 'package:travel_app/presentation/widgets/custom_loading_indicator.dart';
import 'package:travel_app/utils/navigate.dart';

class VerifyRegisterScreen extends StatefulWidget {
  const VerifyRegisterScreen({Key? key, this.isFromLogin = false})
      : super(key: key);

  final bool isFromLogin;

  @override
  State<VerifyRegisterScreen> createState() => _VerifyRegisterScreenState();
}

class _VerifyRegisterScreenState extends State<VerifyRegisterScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      // check the status of the user whether verified or not every 5 seconds
      await FirebaseAuth.instance.currentUser!.reload();
      final user = FirebaseAuth.instance.currentUser!;

      final isEmailVerified = user.emailVerified;
      if (isEmailVerified) {
        timer.cancel();
        if (widget.isFromLogin) {
          Navigator.pop(context);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              bottom: 16,
            ),
            child: RoundedButton(
              press: () => navigateAndRemoveAll(
                  context, widget.isFromLogin ? LoginScreen() : SignUpScreen()),
              text: "Switch Account",
              color: Colors.red,
            ),
          ),
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.04),
                  Text(
                    "Verify Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    "A verification link has been sent to your address. Please click on it to activate.",
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RoundedButton(
                    press: () async {
                      await onSubmit(context);
                      // Resend the email when the user clicks on it
                    },
                    text: "Resend Email",
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  onSubmit(BuildContext context) async {
    onLoading(context);
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    Navigator.pop(context);
  }
}
