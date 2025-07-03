import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrubbrpro/AccountPage.dart';
import 'package:scrubbrpro/AccountPage2.dart';

import 'GigTypeSelectionPage.dart';

class ScrubMapPage extends StatefulWidget {
  const ScrubMapPage({super.key});

  @override
  State<ScrubMapPage> createState() => _ScrubMapPageState();
}

class _ScrubMapPageState extends State<ScrubMapPage> {
  bool isScrubModeOn = false;
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  final LatLng _initialPosition = LatLng(37.7749, -122.4194); // Fallback

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
  }

  void _getLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      setState(() => _currentPosition = position);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ));
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LatLng target = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : _initialPosition;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: target,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => AccountPage2(),
                        transitionsBuilder: (_, animation, __, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          final curve = Curves.fastOutSlowIn;
                          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);
                          return SlideTransition(position: offsetAnimation, child: child, textDirection: TextDirection.rtl);
                        },
                        transitionDuration: const Duration(milliseconds: 275)
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/temp/avatar.jpg'),
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Julian Silva', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Scrubbr', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.notifications_none),
                const SizedBox(width: 10),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 110,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scrub\nMode',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: isScrubModeOn,
                    onChanged: (value) {
                      setState(() => isScrubModeOn = value);

                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const GigTypeSelectionPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0); // slide from bottom
                              const end = Offset.zero;
                              const curve = Curves.easeOut;

                              final tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );
                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                            transitionDuration: const Duration(milliseconds: 400),
                          ),
                        );
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.lightGreenAccent,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 36,
            child: Row(
              children: const [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text('Saturday, Jun 21', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4DB),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(18),
                elevation: 6,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
