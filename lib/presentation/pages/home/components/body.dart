import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/domain/models/place.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/presentation/pages/home/components/popular_item.dart';
import 'package:travel_app/presentation/pages/home/components/popular_text.dart';
import 'package:travel_app/presentation/pages/home/components/sight_item.dart';
import 'package:travel_app/presentation/pages/trips/components/trip_item.dart';
import 'package:travel_app/utils/app_colors.dart';
import 'package:travel_app/utils/size_config.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../../../domain/models/iternary.dart';
import '../../../../infrastructure/services/firebase/firebase_service.dart';
import 'categories_list_view.dart';
import 'search_bar.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  // Declarations
  int i = 0, navBarIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  // List<Place> places = [
  //   Place(
  //       name: 'Djanet excursions',
  //       rating: 4.6,
  //       image: 'assets/images/djanet_2.jpg',
  //       description: 'Description'),
  //   Place(
  //       name: 'Tikejda',
  //       rating: 3.6,
  //       image: 'assets/images/tikjda_2.jpg',
  //       description: 'Description'),
  //   Place(
  //       name: 'El Gour of Brezina',
  //       rating: 3.6,
  //       image: 'assets/images/brezina.jpg',
  //       description: 'Description')
  // ];

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 16,
        ),
        // Padding(
        //     padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
        //     child: SearchBar()),
        // Container(
        //     color: AppColors.grey,

        //     /// no need to provide fix height of container inside column
        //     /// the container will take as much height as its child wants
        //     // height: 200,
        //     width: SizeConfig.screenWidth,
        //     child: Padding(
        //       padding: EdgeInsets.only(top: 10, left: 20, right: 0, bottom: 0),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('CATEGORIES',
        //               style: TextStyles.normal
        //                   .copyWith(color: AppColors.mediumGrey)),
        //           SizedBox(
        //             height: getProportionateScreenHeight(10),
        //           ),
        //           Text("Choose your own adventure",
        //               style: TextStyles.heading.copyWith(fontSize: 15)),
        //           CategoriesListView()
        //         ],
        //       ),
        //     )),
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 0,
                    ),
                    child: PopularText(),
                  ),
                  // Getting data from streams based

                  StreamBuilder(
                      stream:
                          FirebaseManager().getStream(collectionId: "trips"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data == null) {
                          return SizedBox(
                              height: size.height * .2,
                              child: Center(
                                child: Text("No Data"),
                              ));
                        }
                        {
                          final data = (snapshot.data as QuerySnapshot).docs;
                          return ListView.separated(
                            padding: EdgeInsets.all(
                              16,
                            ),
                            itemBuilder: (context, index) {
                              return (data[index]["acceptedUid"] as List)
                                      .contains(
                                FirebaseAuth.instance.currentUser?.uid,
                              )
                                  // If the uid is already in firebase list dont show
                                  ? SizedBox.shrink()
                                  // If the uid is not then allow the user to join the trip

                                  : TripItem(
                                      id: data[index].id,
                                      title: data[index]["name"],
                                      description:
                                          data[index]["description"].toString(),
                                      image: data[index]["image"],
                                      date: data[index]["date"],
                                      acceptedUid:
                                          data[index]["acceptedUid"] ?? [],
                                      toBring: (data[index].data() as Map)["toBring"] ?? [],
                                      itenary: (data[index].data() as Map)["itenary"] != null
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('BEST RATING',
                          style: TextStyles.normal
                              .copyWith(color: AppColors.mediumGrey))),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text("Popular Destinations",
                          style: TextStyles.heading.copyWith(fontSize: 15))),
                  SizedBox(height: 10),
                  // Container(
                  //     height: size.height * 0.35,
                  //     width: size.width,
                  //     // child: ListView.separated(
                  //     //   controller: _scrollController,
                  //     //   physics: ScrollPhysics(),
                  //     //   scrollDirection: Axis.horizontal,
                  //     //   shrinkWrap: true,
                  //     //   itemCount: places.length,
                  //     //   itemBuilder: (BuildContext context, index) {
                  //     //     return AnimatedBuilder(
                  //     //         animation: _scrollController,
                  //     //         builder: (context, child) {
                  //     //           // return Container(
                  //     //           //         imageUrl: places[index].image,
                  //     //           //         name: places[index].name,
                  //     //           //         rating: places[index].rating,
                  //     //           //     );
                  //     //         });
                  //     //   },
                  //     //   separatorBuilder: (BuildContext context, int index) {
                  //     //     return SizedBox(
                  //     //       width: 5,
                  //     //     );
                  //     //   },
                  //     // ),
                  //     child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: places.length,
                  //         itemBuilder: (ctx, index) {
                  //           final image = places[index];
                  //           return Stack(
                  //             children: [
                  //               Positioned(
                  //                 top: 10,
                  //                 right: 10,
                  //                 left: 0,
                  //                 child: Text(
                  //                   image.name.toString(),
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //               Image.asset(image.image.toString()),
                  //             ],
                  //           );
                  //         })),
                ])),
        // Align(
        //   alignment: Alignment.center,
        //   child: ElevatedButton(
        //     child: Text('Log Out'),
        //     onPressed: () async {
        //       await service.signOut();
        //       Navigator.pushNamedAndRemoveUntil(
        //           context, '/welcome', (route) => false);
        //     },
        //   ),
        // ),
      ],
    ));
  }
}
