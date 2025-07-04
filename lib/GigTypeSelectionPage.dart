import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrubbrpro/utils/ScrubbrTimer.dart';

class GigTypeSelectionPage extends StatefulWidget {
  const GigTypeSelectionPage({super.key});

  @override
  State<GigTypeSelectionPage> createState() => _GigTypeSelectionPageState();
}

class _GigTypeSelectionPageState extends State<GigTypeSelectionPage> {
  String selectedType = '';
  bool agreedToTerms = false;
  bool isOnline = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late ScrubbrTimer scrubbrTimer;

  Widget _buildGigButton(String label, Color color, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        height: 50,
        decoration: BoxDecoration(
          color: selected
              ? color
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: label != 'Auto' ? Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87 : selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
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
  Future<void> _start() async {
    final currentContext = context;

    if (selectedType.isEmpty || !agreedToTerms) {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text("Please select gig type and agree to terms!")),
      );
      return;
    }

    try {
      await toggleAvailability(true);
    } catch (e) {
      print("Error in toggleAvailability: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Please try again.")),
      );
      return;
    }

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navigator.of(currentContext).pushReplacementNamed('/dashboard');w
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    scrubbrTimer = ScrubbrTimer(uid: uid); // assuming this is the right constructor
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 60,
                  left: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Choose',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                      Text('Gig',
                          style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('Type',
                          style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Image.asset(
                    'assets/images/bubbles.PNG',
                    width: 120,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          _buildGigButton('Home', const Color(0xFF4FACFE), selectedType == 'Home'),
          _buildGigButton('Auto', const Color(0xFFAaf8db), selectedType == 'Auto'),
          _buildGigButton('Both', const Color(0xFF4FACFE), selectedType == 'Both'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (val) => setState(() => agreedToTerms = val ?? false),
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      style: TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Terms & Policies',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: GestureDetector(
              onTap: _start,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
