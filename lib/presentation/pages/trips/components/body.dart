import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/domain/models/iternary.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';

import 'custom_text.dart';
import 'trip_item.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title: 'Your trips'),
                // Getting data from streams based on uuid
                StreamBuilder(
                    stream: FirebaseAuth.instance.currentUser?.uid ==
                            adminUserId
                        ? FirebaseManager().getStream(
                            collectionId: "trips",
                          )
                        : FirebaseManager().getStreamWithWhereList(
                            collectionId: "trips",
                            whereId: "acceptedUid",
                            whereValue: FirebaseAuth.instance.currentUser?.uid,
                          ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data == null) {
                        return SizedBox(
                            height: size.height * .2,
                            child: Center(
                              child: Text("No Data"),
                            ));
                      } else {
                        final data = (snapshot.data as QuerySnapshot).docs;
                        print(data);
                        print(FirebaseAuth.instance.currentUser?.uid);

                        return ListView.separated(
                          itemBuilder: (context, index) {
                            // Showing trips data in the list
                            // Different trip card created according to data from firebase
                            return TripItem(
                              id: data[index].id,
                              title: data[index]["name"],
                              description:
                                  data[index]["description"].toString(),
                              image: data[index]["image"],
                              date: data[index]["date"],
                              endDate: data[index]["endDate"],
                              acceptedUid: data[index]["acceptedUid"],
                              isHomeScreen: false,
                              toBring:
                                  (data[index].data() as Map)["toBring"] ?? [],
                              itenary: (data[index].data() as Map)["itenary"] !=
                                      null
                                  ? Itenary.fromJson(
                                      (data[index].data() as Map)["itenary"])
                                  : null,
                            );
                          },
                          itemCount: data.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 16,
                          ),
                          shrinkWrap: true,
                          primary: false,
                        );
                      }
                    }),

                // TripItem(
                //   imagePath: AppAssets.ningaloo,
                //   place: 'Ningaloo, Australia',
                //   title: 'Dive with Whale sharks',
                //   date: 'June 30, 2020',
                // ),
                // CustomText(title: 'Completed trips'),
                // TripItem(
                //   imagePath:  AppAssets.peru,
                //   place: 'Cusco, Peru',
                //   title: 'Hiking through the Rainbow Mountain',
                //   date: 'May 30, 2020',
                // ),
              ],
            )));
  }
}
