// lib/scrubbr_timer.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

class ScrubbrTimer {
  final String uid;
  final Duration updateInterval;
  Timer? _locationTimer;

  ScrubbrTimer({
    required this.uid,
    this.updateInterval = const Duration(minutes: 1),
  });

  void start() {
    if (_locationTimer?.isActive ?? false) return;

    _locationTimer = Timer.periodic(updateInterval, (timer) async {
      try {
        LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.best);

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings
        );
        GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
        GeoFirePoint geoFirePoint = GeoFirePoint(geoPoint);

        await FirebaseFirestore.instance.collection('scrubbrs').doc(uid).set({
          'position': geoFirePoint.data,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        print('Location update error: $e');
      }
    });
  }

  void stop() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }
}
