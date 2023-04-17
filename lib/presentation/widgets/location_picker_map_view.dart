import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_button.dart';

class ExLocationPickerMapView extends StatefulWidget {
  final String id;

  final double? latitude;
  final double? longitude;

  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  ExLocationPickerMapView({
    required this.id,
    this.latitude,
    this.longitude,
    required this.latitudeController,
    required this.longitudeController,
  });

  @override
  _ExLocationPickerMapViewState createState() =>
      _ExLocationPickerMapViewState();
}

class _ExLocationPickerMapViewState extends State<ExLocationPickerMapView> {
  @override
  Widget build(BuildContext context) {
    return LocationPickerMap(
      id: widget.id,
      latitude: widget.latitude,
      longitude: widget.longitude,
      latitudeController: widget.latitudeController,
      longitudeController: widget.longitudeController,
    );
  }
}

class LocationPickerMap extends StatefulWidget {
  final String id;
  final double? latitude;
  final double? longitude;
  final double zoom;
  final bool enableMyLocationFeature;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  LocationPickerMap({
    required this.id,
    this.latitude,
    this.longitude,
    this.zoom = 16,
    this.enableMyLocationFeature = true,
    required this.latitudeController,
    required this.longitudeController,
  });

  @override
  LocationPickerMapState createState() => LocationPickerMapState();
}

class LocationPickerMapState extends State<LocationPickerMap> {
  bool loading = true;
  double currentLatitude = -6.200000;
  double currentLongitude = 106.816666;
  late GoogleMapController mapController;

  initData() async {
    if (widget.latitude != null && widget.longitude != null) {
      currentLatitude = widget.latitude ?? currentLatitude;
      currentLongitude = widget.longitude ?? currentLongitude;
    } else {
      print("################");
      print("GetCurrentLocation...###");
      print("################");
      await getCurrentLocation();
      print("################");
      print("GetCurrentLocation [DONE]");
      print("################");

      setState(() {
        loading = false;
      });
    }

    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  getCurrentLocation() async {
    if (Platform.isWindows) return;

    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLatitude = currentLocation.latitude;
    currentLongitude = currentLocation.longitude;
  }

  @override
  void initState() {
    super.initState();
    currentLatitude = widget.latitude ?? currentLatitude;
    currentLongitude = widget.longitude ?? currentLongitude;

    searchController = TextEditingController();
    initData();
  }

  bool updatePosition = false;

  List nominatimSearchResults = [];
  bool nominatimSearchLoading = false;
  void nominatimSearch(search) async {
    if (search.toString().length == 0) return;

    setState(() {
      nominatimSearchLoading = true;
    });

    try {
      nominatimSearchResults.clear();
      http.Response apiResponse = await http.get(
        Uri.parse(
            "https://nominatim.openstreetmap.org/search/$search?format=json&limit=10"),
      );

      nominatimSearchResults.addAll(jsonDecode(apiResponse.body));
      setState(() {});
    } catch (_) {
      print("Nominatim API ERROR");
    }

    setState(() {
      nominatimSearchLoading = false;
    });
  }

  bool typing = true;
  int tryCode = 0;
  late TextEditingController searchController;
  GlobalKey googleMapContainerKey = GlobalKey();
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // setMarkers();
  }

  onTap(LatLng latLng) {
    currentLatitude = latLng.latitude;
    currentLongitude = latLng.longitude;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Positioned(
          //   left: -1000,
          //   top: -1000,
          //   child: Container(
          //     width: 0.0,
          //     height: 0.0,
          //     child: MapViewer(),
          //   ),
          // ),
          if (loading)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: size.width / 2,
                height: 50.0,
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text("Updating Location..."),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!loading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      height: 54.0,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextField(
                              enabled: loading ? false : true,
                              controller: searchController,
                              decoration: InputDecoration.collapsed(
                                hintText: "Select",
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[900],
                              ),
                              onChanged: (text) {
                                tryCode += 1;
                                var currentTryCode = tryCode;

                                Future.delayed(
                                  Duration(milliseconds: 700),
                                  () {
                                    if (tryCode == currentTryCode) {
                                      nominatimSearch(text);
                                    } else {
                                      return;
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () {
                              searchController.text = "";
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      key: googleMapContainerKey,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(widget.latitude ?? 27.700769,
                                    widget.longitude ?? 85.300140),
                                zoom: 15,
                              ),
                              onTap: onTap,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 50.0),
                              child: CustomNetworkImage(
                                "https://icons.iconarchive.com/icons/icons-land/vista-map-markers/96/Map-Marker-Marker-Outside-Azure-icon.png",
                                height: 50.0,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10.0,
                            child: Text("$currentLatitude,$currentLongitude"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(6.0),
                      width: MediaQuery.of(context).size.width,
                      child: RoundedButton(
                        text: "Search",
                        press: () async {
                          widget.latitudeController.text =
                              currentLatitude.toString();
                          widget.longitudeController.text =
                              currentLongitude.toString();

                          // final provider =
                          //     Provider.of<VmEditVendorFormProvider>(context,
                          //         listen: false);
                          // provider.latitudeController.text =
                          //     currentLatitude.toString();
                          // provider.longitudeController.text =
                          //     currentLongitude.toString();

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (nominatimSearchLoading || nominatimSearchResults.length > 0)
            Positioned(
              left: 0,
              right: 0,
              top: 50,
              bottom: 0,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: SafeArea(
                      child: Column(
                        children: [
                          if (nominatimSearchLoading)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "Searching...",
                                style: TextStyle(
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                          if (nominatimSearchResults.length > 0)
                            Container(
                              color: Colors.white,
                              height: 500.0,
                              child: Wrap(
                                  children: List.generate(
                                      nominatimSearchResults.length, (index) {
                                var item = nominatimSearchResults[index];
                                var displayName = item["display_name"];
                                var lat = double.parse(item["lat"].toString());
                                var lng = double.parse(item["lon"].toString());

                                return InkWell(
                                  onTap: () async {
                                    updatePosition = true;
                                    currentLatitude = lat;
                                    currentLongitude = lng;

                                    print("set Latitude to $lat");
                                    print("set Longitude to $lng");

                                    nominatimSearchResults = [];

                                    searchController.text =
                                        item["display_name"];

                                    mapController.moveCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(
                                            currentLatitude,
                                            currentLongitude,
                                          ),
                                        ),
                                      ),
                                    );

                                    setState(() {
                                      nominatimSearchResults = [];
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: Text(
                                      displayName,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(this.imageURL,
      {this.fit,
      this.color,
      this.height,
      this.width,
      this.borderRadius = 20,
      Key? key})
      : super(key: key);
  final String imageURL;
  final BoxFit? fit;
  final Color? color;
  final double? height;
  final double? width;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: CachedNetworkImage(
        imageUrl: imageURL,
        fit: fit,
        color: color,
        height: height,
        width: width,

        // placeholder: (context, url) => Image.asset("assets/image/image_placeholder.png"),
        progressIndicatorBuilder: (BuildContext context, String url,
                DownloadProgress downloadProgress) =>
            const CircularProgressIndicator.adaptive(),
        errorWidget: (BuildContext context, String url, dynamic _) {
          log(url, name: "url");
          return const Icon(Icons.error, color: Colors.grey);
        },
      ),
    );
  }
}
