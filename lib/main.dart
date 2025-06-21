import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScrubbrProApp());
}

class ScrubbrProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrubbr Pro',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return Dashboard();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<void> requestLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // You can show a dialog asking the user to enable permissions from settings
      print('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      print('Location permission granted.');
    }
  }
  @override
  void initState() {
    super.initState();
    requestLocationPermissions();
  }

  bool isOnline = false;
  final geo = GeoFirePoint(GeoPoint(35.681236, 139.767125));

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> toggleAvailability(bool value) async {
    setState(() => isOnline = value);

    if (isOnline) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('Please enable location permissions in settings.'),
            actions: [
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  Geolocator.openAppSettings();
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      // Proceed if permission is granted
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await FirebaseFirestore.instance.collection('scrubbrs').doc(uid).set({
        'isOnline': true,
        'position': geo.data,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await FirebaseFirestore.instance.collection('scrubbrs').doc(uid).set({
        'isOnline': false,
      }, SetOptions(merge: true));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scrubbr Pro Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Availability'),
            Switch(value: isOnline, onChanged: toggleAvailability),
          ],
        ),
      ),
    );
  }
}
