import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) =>
        Navigator.pushNamedAndRemoveUntil(
            context, '/welcome', (route) => false));
    // Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Align(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}
