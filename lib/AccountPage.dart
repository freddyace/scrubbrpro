import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? Center(child: Text('No user logged in.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.camera_alt, size: 40),
            ),
            SizedBox(height: 16),
            Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user!.displayName ?? 'Not available'),
            SizedBox(height: 16),
            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user!.email ?? 'Not available'),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Return to login/home
              },
              icon: Icon(Icons.logout),
              label: Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
