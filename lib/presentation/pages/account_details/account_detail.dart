import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_button.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_input_field.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/presentation/widgets/custom_loading_indicator.dart';
import 'package:travel_app/utils/show_toast_message.dart';

import '../../../infrastructure/services/firebase/firebase_service.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({Key? key}) : super(key: key);

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'N/a';
    final String name = user?.displayName ?? 'N/a';
    final String phone = user?.phoneNumber ?? 'N/a';

    final nameController = TextEditingController();
    final addressController = TextEditingController();
    // final uid = user?.uid ?? 'N/a';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff0A3579),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/profile_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: kPrimaryColor,
                    child: IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/welcome', (route) => false);
                      },
                      icon: Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hello!! ${email.split("@").first}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Your Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Email: $email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              FutureBuilder(
                  future: FirebaseManager().getData(
                      collectionId: "profile",
                      whereId: "email",
                      whereValue: email),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
        
                    final data = (snapshot.data as QuerySnapshot).docs;
                    // print();
                    if (data.isNotEmpty) {
                      final d = data.first.data() as Map;
                      nameController.text = d["name"];
                      addressController.text = d["address"];
                    }
                    return Column(
                      children: [
                        RoundedInputField(
                          hintText: "Your Name",
                          onChanged: (value) {},
                          controller: nameController,
                        ),
                        SizedBox(height: 16),
                        RoundedInputField(
                          hintText: "Your Address",
                          onChanged: (value) {},
                          icon: Icons.location_on_outlined,
                          controller: addressController,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        RoundedButton(
                          text: "Save",
        
                          //firebase login code..
                          press: () async {
                            try {
                              final map = {
                                "name": nameController.text,
                                "address": addressController.text,
                                "email": email,
                              };
                              onLoading(context);
                              FirebaseManager().addOrUpdateContent(
                                context,
                                collectionId: "profile",
                                whereId: "email",
                                whereValue: email,
                                map: map,
                              );
                              showToast("Successfully changed profile");
                            } catch (e) {
                              print(e.toString());
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
