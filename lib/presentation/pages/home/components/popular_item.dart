import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/utils/app_assets.dart';
import 'package:travel_app/utils/app_colors.dart';
import 'package:travel_app/utils/show_toast_message.dart';
import 'package:travel_app/utils/size_config.dart';
import 'package:travel_app/utils/text_styles.dart';

class PopularItem extends StatelessWidget {
  final String name;
  final String id;
  final String subtitle;
  final String image;
  final String date;
  final List<dynamic> acceptedUid;

  PopularItem({
    Key? key,
    required this.id,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.date,
    required this.acceptedUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Container(
          width: double.infinity,
          // height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFfae3e2).withOpacity(0.3),
                offset: Offset(0.0, 1.0),
                blurRadius: 9.0,
              ),
            ],
          ),
          child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              child: Container(
                // height: 100,
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.screenWidth! * 1,
                      height: SizeConfig.screenHeight! * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: MemoryImage(base64Decode(image)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ...[
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "$name",
                                      style: TextStyles.bold.copyWith(
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "$subtitle",
                                      style: TextStyles.regular2.copyWith(
                                        color: AppColors.secondaryColor,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ].expand(
                                  (widget) => [
                                    widget,
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 6,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: kPrimaryColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            date,
                          ),
                          Spacer(),
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
