import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String locationMessage = "Location not determined";

  Future<void> _getLocation() async {
    // Check location permissions
    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          locationMessage =
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        });
      } catch (e) {
        setState(() {
          locationMessage = "Error getting location: $e";
        });
      }
    } else {
      setState(() {
        locationMessage = "Location permission denied";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location Permission'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locationMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text("Get Current Location"),
            ),
            ElevatedButton(
             onPressed: () {
             Navigator.pushNamed(context, '/location');
               },
             child: Text('Request Location'),
            ),
          ],
        ),
      ),
    );
  }
}
