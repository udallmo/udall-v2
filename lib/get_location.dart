import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class GetLocation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GetLocationState();
  }
}

class GetLocationState extends State<GetLocation> {
  Future output;

  @override
  void initState() {
    super.initState();

    output = checkStatus();
  }
  

  getDistance(lat, long) {
    // double ulat = 43.4401679;
    // double ulong = -80.5238747;
    double ulat = 43.465230;
    double ulong = -80.522405;

    int radius = 6371;

    double _lat = rad(lat - ulat);
    double _long = rad(long - ulong);

    double a = math.sin(_lat / 2) * math.sin(_lat / 2) +
        math.cos(rad(ulat)) *
            math.cos(rad(lat)) *
            math.sin(_long / 2) *
            math.sin(_long / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = radius * c;

    return d;
  }

  rad(deg) {
    return deg * (math.pi / 180);
  }

  Future<String> checkStatus() async {
    Location location = new Location();
    double footlong = 0.0003048000;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return '';
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return '';
      }
    }

    _locationData = await location.getLocation();
    double distance =
        getDistance(_locationData.latitude, _locationData.longitude);

    distance = distance / footlong;

    return distance.round().toString();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: output,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Text(
            'You are ${snapshot.data} footlongs away from me!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          );
        } else {
          return Text('You are pretty far away from me! :(');
        }
      },
    );
  }
}
