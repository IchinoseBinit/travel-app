import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/domain/models/iternary.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/presentation/pages/chats/chat_screen.dart';
import 'package:travel_app/presentation/pages/home/trip_detail_screen.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/utils/app_colors.dart';
import 'package:travel_app/utils/navigate.dart';
import 'package:travel_app/utils/show_toast_message.dart';
import 'package:travel_app/utils/size_config.dart';
import 'package:travel_app/utils/text_styles.dart';

// Items for trips posted

class TripItem extends StatelessWidget {
  const TripItem({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.endDate,
    required this.image,
    required this.acceptedUid,
    this.isHomeScreen = true,
    required this.itenary,
    required this.toBring,
  }) : super(key: key);

  final String description;
  final String title;
  final String date;
  final String? endDate;
  final dynamic image;
  final String id;
  final List<dynamic> acceptedUid;
  final bool isHomeScreen;

  final List<dynamic> toBring;
  final Itenary? itenary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () => navigate(
            context,
            TripDetail(
              description: description,
              title: title,
              date: date,
              endDate: endDate,
              image: image,
              toBring: toBring,
              itenary: itenary,
            )),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            // height: getProportionateScreenHeight(is 220),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: getProportionateScreenHeight(115),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    image: DecorationImage(
                      image: MemoryImage(
                        base64Decode(
                          image.runtimeType == String
                              ? image
                              : (image as List).first,
                        ),
                      ), //
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          date, //
                          style: TextStyles.normal.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        if (endDate != null) ...[
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            endDate!, //
                            style: TextStyles.normal.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ]
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Text(
                    title,
                    style: TextStyles.heading.copyWith(fontSize: 14),
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(top: isHomeScreen ? 5 : 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: SizeConfig.screenWidth! * .7,
                          child: Text(
                            description,
                            style: TextStyles.regular2.copyWith(
                              color: AppColors.black,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        if (isHomeScreen)
                          InkWell(
                            onTap: () async {
                              await FirebaseManager().updateData(
                                context,
                                map: {
                                  "acceptedUid": [
                                    ...acceptedUid,
                                    FirebaseAuth.instance.currentUser?.uid,
                                  ],
                                },
                                collectionId: "trips",
                                docId: id,
                              );
                              showToast("Successfully joined the trip");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: () async {
                              navigate(
                                context,
                                ChatScreen(
                                  tripId: id,
                                  tripTitle: title,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.chat,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
