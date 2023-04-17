import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/presentation/pages/map/network_helper.dart';

import '../../../infrastructure/services/firebase/firebase_manager.dart';
import '../login-signup/constants.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  GoogleMapController? mapController;

  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;

  LatLng? userLocation;

  // Dummy Start and Destination Points
  double startLat = 27.700769;
  double startLng = 85.300140;
  double endLat = 27.6688312;
  double endLng = 85.3077329;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // setMarkers();
  }

  // setMarkers() {
  //   markers.add(
  //     Marker(
  //       markerId: MarkerId("Home"),
  //       position: LatLng(startLat, startLng),
  //       infoWindow: InfoWindow(
  //         title: "Home",
  //         snippet: "Home Sweet Home",
  //       ),
  //     ),
  //   );

  //   markers.add(Marker(
  //     markerId: MarkerId("Destination"),
  //     position: LatLng(endLat, endLng),
  //     infoWindow: InfoWindow(
  //       title: "Random Location",
  //       snippet: "5 star ratted place",
  //     ),
  //   ));
  //   setState(() {});
  // }

  void getJsonData(LatLng latLng) async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: userLocation!.latitude,
      startLng: userLocation!.longitude,
      endLat: latLng.latitude,
      endLng: latLng.longitude,
    );

    try {
      // polyLines.clear();
      // getData() returns a json Decoded data
      polyLines.clear();

      data = await network.getData();
      final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines(polyPoints);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

// For holding Co-ordinates as LatLng
  setPolyLines(List<LatLng> polyPoints) {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.green,
      points: polyPoints,
      width: 5,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    GeolocatorPlatform.instance.getCurrentPosition().then(
      (value) {
        userLocation = LatLng(value.latitude, value.longitude);
        markers.add(
          Marker(
            markerId: MarkerId("Current Location"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(
                  title: "User Location",
                ),
          ),
        );
        setState(() {});
      },
    );

    // getJsonData();
  }

  onTap(LatLng latLng) {
    markers.add(
      Marker(
        markerId: MarkerId("Destination"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    );
    setState(() {});
    if (userLocation != null) getJsonData(latLng);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseManager().getStream(
                collectionId: "trips",
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
            for (var eachData in data) {
              final d = eachData.data() as Map;
              double lat;
              double lon;
              if (d["latitude"] != null) {
                 lat = double.tryParse(d["latitude"].toString()) ?? endLat;
                 lon =
                    double.tryParse(d["longitude"].toString()) ?? endLng;
              } else {
                lat = endLat;
                lon = endLng;
              }
              markers.add(Marker(
                markerId: MarkerId(eachData.id),
                position: LatLng(lat, lon),
                infoWindow: InfoWindow(
                  title: d["name"],
                ),
              ));
            }

            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: const LatLng(27.700769, 85.300140),
                zoom: 9,
              ),
              onTap: onTap,
              markers: markers,
              polylines: polyLines,
            );
          }
        },
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
