import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrubbrpro/AccountPage.dart';
import 'package:scrubbrpro/PayoutsPage.dart';
import 'package:scrubbrpro/SupportPage.dart';
import 'package:scrubbrpro/utils/ScrubbrTimer.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isOnline = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late ScrubbrTimer scrubbrTimer;
  int _selectedIndex = 0;
  Future<void> requestLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // You can show a dialog asking the user to enable permissions from settings
      print('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      print('Location permission granted.');
    }
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermissions();
    scrubbrTimer = ScrubbrTimer(uid: uid);
  }

  Future<void> toggleAvailability(bool value) async {
    setState(() => isOnline = value);

    if (isOnline) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle denied permissions
        return;
      }

      // Mark online in Firestore
      await FirebaseFirestore.instance.collection('scrubbrs').doc(uid).set({
        'isOnline': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Start background timer
      scrubbrTimer.start();
    } else {
      // Mark offline in Firestore
      await FirebaseFirestore.instance.collection('scrubbrs').doc(uid).set({
        'isOnline': false,
      }, SetOptions(merge: true));

      // Stop location tracking
      scrubbrTimer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrubbr Pro Dashboard'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Availability'),
            Switch(value: isOnline, onChanged: toggleAvailability),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Freddy Acevedo'),
            ),
            ListTile(
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Account'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Close Drawer
                Navigator.pop(context);
                // Go to Account Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Payouts'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // Go to Account Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PayoutsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Support'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // Go to Account Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
