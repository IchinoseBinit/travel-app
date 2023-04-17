import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_button.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/presentation/widgets/location_picker_map_view.dart';

class ExLocationPicker extends StatefulWidget {
  final String id;
  final String? label;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  ExLocationPicker({
    required this.id,
    this.label,
    required this.latitudeController,
    required this.longitudeController,
  });

  @override
  _ExLocationPickerState createState() => _ExLocationPickerState();
}

class _ExLocationPickerState extends State<ExLocationPicker> {
  @override
  void initState() {
    super.initState();
  }

  bool isLocationPicked() {
    if (widget.latitudeController.text.isNotEmpty &&
        widget.longitudeController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLocationPicked())
              RoundedButton(
                text: "Select Location",
                color: kPrimaryLightColor,
                textColor: kPrimaryColor,
                press: () async {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final val =
                        await GeolocatorPlatform.instance.requestPermission();
                    if (val == LocationPermission.always ||
                        val == LocationPermission.whileInUse) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExLocationPickerMapView(
                            id: widget.id,
                            latitudeController: widget.latitudeController,
                            longitudeController: widget.longitudeController,
                          ),
                        ),
                      );
                      setState(() {});
                    } else {
                      // showSnackbar(context: context)
                    }
                    return;
                  }

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExLocationPickerMapView(
                        id: widget.id,
                        latitudeController: widget.latitudeController,
                        longitudeController: widget.longitudeController,
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
            if (isLocationPicked())
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExLocationPickerMapView(
                        id: widget.id,
                        latitudeController: widget.latitudeController,
                        longitudeController: widget.longitudeController,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                  setState(() {});
                },
                child: Container(
                  color: kPrimaryLightColor,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Selected Latitude: ${widget.latitudeController.text.toString()}\nLongitude: ${widget.longitudeController.text.toString()}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                      Spacer(),
                      Icon(
                        Icons.edit,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
