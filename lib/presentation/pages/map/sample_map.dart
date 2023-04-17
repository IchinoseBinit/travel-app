// // import 'dart:async';
// // import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart' as travel;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

// class MapSample extends StatefulWidget {
//   @override
//   _MapSampleState createState() => _MapSampleState();
// }

// class _MapSampleState extends State<MapSample> {
//   GoogleMapController? mapController; //contrller for Google map
//   PolylinePoints polylinePoints = PolylinePoints();

//   String googleAPiKey = "AIzaSyAsk5meZQipi4l7sw9_W4nxVtjk0vUJzbg";

//   Set<Marker> markers = Set(); //markers for google map
//   Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
//   Set<Polyline> polylines2 = {}; //polylines to show direction

//   final List<LatLng> polyPoints = [];
//   var data;
//   LatLng startLocation = LatLng(27.700769, 85.300140);
//   LatLng endLocation = LatLng(27.6688312, 85.3077329);

//   @override
//   void initState() {
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: startLocation, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Starting Point ',
//         snippet: 'Start Marker',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));

//     markers.add(Marker(
//       //add distination location marker
//       markerId: MarkerId(endLocation.toString()),
//       position: endLocation, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Destination Point ',
//         snippet: 'Destination Marker',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));

//     getDirections(); //fetch direction polylines from Google API

//     super.initState();
//   }

//   getDirections() async {
//     List<LatLng> polylineCoordinates = [];

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleAPiKey,
//       PointLatLng(startLocation.latitude, startLocation.longitude),
//       PointLatLng(endLocation.latitude, endLocation.longitude),
//       travelMode: travel.TravelMode.driving,
//     );

//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     addPolyLine(polylineCoordinates);
//   }

//   addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.blue,
//       // points: polylineCoordinates,
//       points: [
//         LatLng(27.700769, 85.300140),
//         LatLng(27.6688312, 85.3077329),
//       ],
//       width: 8,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     String location = "Search Location";
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Route Driection in Google Map"),
//       //   backgroundColor: Colors.deepPurpleAccent,
//       // ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             //Map widget from google_maps_flutter package
//             zoomGesturesEnabled: true, //enable Zoom in, out on map
//             initialCameraPosition: CameraPosition(
//               //innital position in map
//               target: startLocation, //initial position
//               zoom: 16.0, //initial zoom level
//             ),
//             markers: markers, //markers to show on map
//             // polylines: Set<Polyline>.of(polylines.values), //polylines
//             polylines: polylines2,
//             mapType: MapType.normal, //map type
//             onMapCreated: (controller) {
//               //method called when map is created
//               setState(() {
//                 mapController = controller;
//               });
//             },
//           ),
//           //search autoconplete input
//           Positioned(
//             //search input bar
//             top: 30,
//             child: InkWell(
//               onTap: () async {
//                 var place = await PlacesAutocomplete.show(
//                     context: context,
//                     apiKey: googleAPiKey,
//                     mode: Mode.overlay,
//                     types: [],
//                     strictbounds: false,
//                     components: [Component(Component.country, 'np')],
//                     //google_map_webservice package
//                     onError: (err) {
//                       print(err);
//                     });

//                 if (place != null) {
//                   setState(
//                     () {
//                       location = place.description.toString();
//                     },
//                   );

//                   //form google_maps_webservice package
//                   final plist = GoogleMapsPlaces(
//                     apiKey: googleAPiKey,
//                     apiHeaders: await GoogleApiHeaders().getHeaders(),
//                     //from google_api_headers package
//                   );
//                   String placeid = place.placeId ?? "0";
//                   final detail = await plist.getDetailsByPlaceId(placeid);
//                   final geometry = detail.result.geometry!;
//                   final lat = geometry.location.lat;
//                   final lang = geometry.location.lng;
//                   var newlatlang = LatLng(lat, lang);

//                   //move map camera to selected place with animation
//                   mapController?.animateCamera(CameraUpdate.newCameraPosition(
//                       CameraPosition(target: newlatlang, zoom: 17)));
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.all(15),
//                 child: Card(
//                   child: Container(
//                     padding: EdgeInsets.all(0),
//                     width: MediaQuery.of(context).size.width - 40,
//                     child: ListTile(
//                       title: Text(
//                         location,
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       trailing: Icon(Icons.search),
//                       dense: true,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// /// Google Map Search...

// // class MapSample extends StatefulWidget {
// //   @override
// //   _MapSampleState createState() => _MapSampleState();
// // }

// // class _MapSampleState extends State<MapSample> {
// //   // Completer<GoogleMapController> _controller = Completer();

// //   /// kathmandu
// //   static const LatLng _center = const LatLng(27.700769, 85.300140);

// //   // void _onMapCreated(GoogleMapController controller) {
// //   //   _controller.complete(controller);
// //   // }

// //   String googleApikey = "AIzaSyAsk5meZQipi4l7sw9_W4nxVtjk0vUJzbg";
// //   GoogleMapController? mapController; //contrller for Google map
// //   CameraPosition? cameraPosition;
// //   LatLng startLocation = LatLng(27.6602292, 85.308027);
// //   String location = "Search Location";

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         // appBar: AppBar(
// //         //   title: Text('Map Sample'),
// //         //   backgroundColor: Colors.green,
// //         // ),
// //         // body: Stack(
// //         //   children: [
// //         //     GoogleMap(
// //         //       mapToolbarEnabled: true,
// //         //       myLocationEnabled: true,
// //         //       onMapCreated: _onMapCreated,
// //         //       initialCameraPosition: CameraPosition(
// //         //         target: _center,
// //         //         zoom: 15.0,
// //         //       ),
// //         //     ),
// //         //   ],
// //         // ),
// //         body: Stack(
// //           children: [
// //             GoogleMap(
// //               //Map widget from google_maps_flutter package
// //               zoomGesturesEnabled: true, //enable Zoom in, out on map
// //               initialCameraPosition: CameraPosition(
// //                 //innital position in map
// //                 target: startLocation, //initial position
// //                 zoom: 14.0, //initial zoom level
// //               ),
// //               mapType: MapType.normal, //map type
// //               onMapCreated: (controller) {
// //                 //method called when map is created
// //                 setState(() {
// //                   mapController = controller;
// //                 });
// //               },
// //             ),

// //             //search autoconplete input
// //             Positioned(
// //               //search input bar
// //               top: 10,
// //               child: InkWell(
// //                 onTap: () async {
// //                   var place = await PlacesAutocomplete.show(
// //                       context: context,
// //                       apiKey: googleApikey,
// //                       mode: Mode.overlay,
// //                       types: [],
// //                       strictbounds: false,
// //                       components: [Component(Component.country, 'np')],
// //                       //google_map_webservice package
// //                       onError: (err) {
// //                         print(err);
// //                       });

// //                   if (place != null) {
// //                     setState(
// //                       () {
// //                         location = place.description.toString();
// //                       },
// //                     );

// //                     //form google_maps_webservice package
// //                     final plist = GoogleMapsPlaces(
// //                       apiKey: googleApikey,
// //                       apiHeaders: await GoogleApiHeaders().getHeaders(),
// //                       //from google_api_headers package
// //                     );
// //                     String placeid = place.placeId ?? "0";
// //                     final detail = await plist.getDetailsByPlaceId(placeid);
// //                     final geometry = detail.result.geometry!;
// //                     final lat = geometry.location.lat;
// //                     final lang = geometry.location.lng;
// //                     var newlatlang = LatLng(lat, lang);

// //                     //move map camera to selected place with animation
// //                     mapController?.animateCamera(CameraUpdate.newCameraPosition(
// //                         CameraPosition(target: newlatlang, zoom: 17)));
// //                   }
// //                 },
// //                 child: Padding(
// //                   padding: EdgeInsets.all(15),
// //                   child: Card(
// //                     child: Container(
// //                       padding: EdgeInsets.all(0),
// //                       width: MediaQuery.of(context).size.width - 40,
// //                       child: ListTile(
// //                         title: Text(
// //                           location,
// //                           style: TextStyle(fontSize: 18),
// //                         ),
// //                         trailing: Icon(Icons.search),
// //                         dense: true,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
