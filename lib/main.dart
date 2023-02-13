import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:LocatorApp_maps_flutter/LocatorApp_maps_flutter.dart';

void main()
{
  runApp(
    MaterialApp(
      home: LocatorApp(),
    ),
  );
}

class LocatorApp extends StatefulWidget {
  const LocatorApp({Key? key}) : super(key: key);

  @override
  State<LocatorApp> createState() => _LocatorAppState();
}

class _LocatorAppState extends State<LocatorApp> {

  Completer<LocatorAppMapController> _controller = Completer();
  // on below line we have specified camera position
  static final CameraPosition _kLocatorApp = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )
    ),
  ];

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LocatorAppMap(
        onMapCreated: (LocatorAppMapController controller){
          _controller.complete(controller);
        },
        initialCameraPosition: _kLocatorApp,
        myLocationEnabled: true,
        // mapType: MapType.hybrid,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FloatingActionButton(
          onPressed: () async{
            getUserCurrentLocation().then((value) async {
              print(value.latitude.toString() +" "+value.longitude.toString());

              // marker added for current users location
              _markers.add(
                  Marker(
                    markerId: MarkerId("2"),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(
                      title: 'My Current Location',
                    ),
                  )
              );

              // specified current users location
              CameraPosition cameraPosition = new CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 14,
              );

              final LocatorAppMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {
              });
            });
          },
          child: Icon(Icons.local_activity),
        ),
      ),
    );
  }
}
