import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/domain/models/iternary.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/presentation/pages/home/iternary_post_screen.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_button.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_input_field.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/presentation/widgets/location_picker.dart';
import 'package:travel_app/utils/file_compressor.dart';
import 'package:travel_app/utils/show_toast_message.dart';
import 'package:travel_app/utils/size_config.dart';

class TripPostScreen extends StatefulWidget {
  TripPostScreen({Key? key}) : super(key: key);

  @override
  State<TripPostScreen> createState() => _TripPostScreenState();
}

class _TripPostScreenState extends State<TripPostScreen> {
  // final imageController = TextEditingController();

  final nameController = TextEditingController();

  final descriptionController = TextEditingController();

  final dateController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  List<String> toBring = [];
  List<String> images = [];
  Itenary? itenary;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Trip"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Fill the information about the trip",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .02,
              ),
              Center(
                child: SizedBox(
                    // height: SizeConfig.screenHeight! * .15,
                    // width: SizeConfig.screenWidth! * 1,
                    child: images.isEmpty
                        ? Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: SizeConfig.screenHeight! * .12,
                                color: kPrimaryColor,
                              ),
                              Text(
                                "Upload Image",
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          )
                        : SizedBox(
                          child: Wrap(
                              spacing: SizeConfig.screenWidth! * .02,
                              children: images
                                  .map(
                                    (e) => Image.memory(
                                      base64Decode(e),
                                      height: SizeConfig.screenWidth! * .30,
                                      width: SizeConfig.screenWidth! * .30,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  .toList(),
                            ),
                        )),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedInputField(
                hintText: "Trip Name",
                controller: nameController,
                icon: Icons.trip_origin_outlined,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedInputField(
                hintText: "Description",
                controller: descriptionController,
                maxLines: 5,
                icon: Icons.description_outlined,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedInputField(
                hintText: "Date",
                controller: dateController,
                icon: Icons.calendar_month_outlined,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedButton(
                press: () async {
                  await showBottomSheet(context);
                  // Navigator.pop();
                  setState(() {});
                  // if (map.isNotEmpty) {}
                },
                color: kPrimaryLightColor,
                text: "Choose Image",
                textColor: kPrimaryColor,
              ),
              Container(
                // margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ExLocationPicker(
                  id: "location",
                  label: "Location",
                  latitudeController: latitudeController,
                  longitudeController: longitudeController,
                ),
              ),
              if (itenary != null || toBring.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8.0),
                  child: Text("Itenary Data Saved"),
                )
              else
                RoundedButton(
                  press: () async {
                    if (dateController.text.isEmpty) {
                      showToast(
                          "Cannot select itenary if the date is not selected");
                      return;
                    }
                    final data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItenaryPostScreen(
                          date: dateController.text,
                        ),
                      ),
                    );
                    if (data != null) {
                      toBring = data[0];
                      itenary = data[1];
                      setState(() {});
                    }
                  },
                  color: kPrimaryLightColor,
                  text: "Iternaries",
                  textColor: kPrimaryColor,
                ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedButton(
                text: "Submit",
                press: () async {
                  onSubmit(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context) async {
    final imagePicker = ImagePicker();
    final xFiles = await imagePicker.pickMultiImage();
    if (xFiles != null) {
      for (var xFile in xFiles) {
        final int sizeInBytes = await xFile.length();
        final double sizeInMb = sizeInBytes / 1000000;
        if (sizeInMb > 1.0) {
          final compressedFile = await compressFile(xFile);
          if (compressedFile != null) {
            images.add(base64Encode(compressedFile));
          }
        } else {
          final unit8list = await xFile.readAsBytes();
          images.add(base64Encode(unit8list));
        }
      }
      setState(() {});
    }
  }

  Column buildChooseOptions(
    BuildContext context, {
    required Function func,
    required IconData iconData,
    required String label,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            print("object");
            func();
          },
          color: kPrimaryColor,
          iconSize: SizeConfig.screenHeight! * .06,
          icon: Icon(iconData),
        ),
        Text(label),
      ],
    );
  }

  onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        if (images.isEmpty) {
          showToast("Please upload an image");
          return;
        } else if (latitudeController.text.isEmpty) {
          showToast("Please select a location");
          return;
        } else if (toBring.isEmpty && itenary == null) {
          showToast("Please select a itenary");
          return;
        }

        final map = {
          "name": nameController.text,
          "description": descriptionController.text,
          "date": dateController.text,
          "image": images,
          "latitude": latitudeController.text,
          "longitude": longitudeController.text,
          "acceptedUid": [],
          "toBring": toBring,
          "itenary": itenary?.toJson(),
        };
        // GeneralAlertDialog().customLoadingDialog(context);
        // await Provider.of<FoodProvider>(context, listen: false)
        //     .addFoodPost(context, food);
        await FirebaseManager()
            .addData(context, map: map, collectionId: "trips");
        Navigator.pop(context);
        // Navigator.pop(context);
      } catch (ex) {
        // Navigator.pop(context);
        showToast(ex.toString());
        // GeneralAlertDialog().customAlertDialog(context, ex.toString());
      }
    }
  }
}
