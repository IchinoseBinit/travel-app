import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_app/domain/models/iternary.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/utils/app_colors.dart';
import 'package:travel_app/utils/size_config.dart';
import 'package:travel_app/utils/text_styles.dart';

class TripDetail extends StatelessWidget {
  const TripDetail({
    Key? key,
    required this.description,
    required this.title,
    required this.date,
    required this.image,
    required this.toBring,
    required this.itenary,
  }) : super(key: key);

  final String description;
  final String title;
  final String date;
  final String image;
  final List<dynamic> toBring;
  final Itenary? itenary;

  @override
  Widget build(BuildContext context) {
    print(itenary);
    print("hello");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
          ),
          elevation: 3,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                // height: getProportionateScreenHeight(is 220),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(215),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        image: DecorationImage(
                          image: MemoryImage(
                            base64Decode(
                              image,
                            ),
                          ), //
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
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
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        title,
                        style: TextStyles.heading.copyWith(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    if (toBring.isNotEmpty) ...[
                      Text(
                        "To Bring",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ListView.separated(
                        separatorBuilder: (_, __) => SizedBox(
                          height: 8,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (_, index) => Text(
                          "${(index + 1)}. ${toBring[index]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        itemCount: toBring.length,
                        shrinkWrap: true,
                        primary: false,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                    if (itenary != null) ...[
                      Text(
                        "Itenary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (itenary != null) ...[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          itenary!.date,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ListView.separated(
                          separatorBuilder: (_, __) => SizedBox(
                            height: 8,
                          ),
                          itemBuilder: (_, index) => Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  itenary!.details[index].time,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: kPrimaryLightColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                itenary!.details[index].name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          itemCount: itenary!.details.length,
                          shrinkWrap: true,
                          primary: false,
                        ),
                      ] else
                        Center(child: Text("No Itenaries added"))
                    ],
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
