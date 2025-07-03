import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scrubbrpro/CreateAccount.dart';
import 'package:scrubbrpro/GigTypeSelectionPage.dart';
import 'package:scrubbrpro/ScrubbrLoginScreen.dart';
import 'package:scrubbrpro/SupportChatScreen.dart';
import 'AuthGate.dart';

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ScrubbrProApp());
}

class ScrubbrProApp extends StatefulWidget {
  @override
  _ScrubbrProAppState createState() => _ScrubbrProAppState();
}

class _ScrubbrProAppState extends State<ScrubbrProApp> {
  @override
  void initState() {
    super.initState();
    initFCM();
  }

  void initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // iOS: Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🛂 User granted permission: ${settings.authorizationStatus}');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground message received: ${message.notification?.title}');
      // You can also show a dialog/snackbar here
    });

    // Handle when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 Notification tapped: ${message.data}');
      // Navigate based on message.data if needed
    });

    // (Optional) Get and print FCM token
    String? token = await messaging.getToken();
    print('📱 FCM Token: $token');

    // OPTIONAL: Save the token to Firestore under the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('scrubbrs').doc(user.uid).update({
        'fcmToken': token,
      });
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("FCM Token Refreshed: $newToken");

      // OPTIONAL: Save updated token
      if (user != null) {
        await FirebaseFirestore.instance.collection('scrubbrs').doc(user.uid).update({
          'fcmToken': newToken,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrubbr Pro',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: AuthGate(),
      routes: {
        '/login': (context) => const ScrubbrLoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/support-chat': (context) => const SupportChatScreen(),
        '/select-gig-type': (context) => const GigTypeSelectionPage()
      },
    );
  }
}
