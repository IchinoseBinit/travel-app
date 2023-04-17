import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/presentation/pages/home/trip_post_screen.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/utils/size_config.dart';
import 'components/body.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.uid);
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      floatingActionButton:
          FirebaseAuth.instance.currentUser?.uid == adminUserId
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TripPostScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
              : SizedBox.shrink(),
    );
  }
}
