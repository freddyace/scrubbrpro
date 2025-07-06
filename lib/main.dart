import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scrubbrpro/CreateAccount.dart';
import 'package:scrubbrpro/GigTypeSelectionPage.dart';
import 'package:scrubbrpro/NotificationsPage.dart';
import 'package:scrubbrpro/ScrubMapPage.dart';
import 'package:scrubbrpro/ScrubbrLoginScreen.dart';
import 'package:scrubbrpro/SupportChatScreen.dart';
import 'package:scrubbrpro/TermsOfServicePage.dart';
import 'package:scrubbrpro/utils/InheritedWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthGate.dart';
import 'ResetPasswordPage.dart';

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  // Set background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ScrubbrProApp(isDarkMode: isDarkMode));
}

class ScrubbrProApp extends StatefulWidget {
  final bool isDarkMode;
  const ScrubbrProApp({super.key, required this.isDarkMode});

  @override
  _ScrubbrProAppState createState() => _ScrubbrProAppState();
}

class _ScrubbrProAppState extends State<ScrubbrProApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    initFCM();
  }
  void _toggleTheme(bool value) async {
    setState(() => _isDarkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
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
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: AuthGate(),
        routes: {
          '/login': (context) => const ScrubbrLoginScreen(),
          '/create-account': (context) => const CreateAccountScreen(),
          '/support-chat': (context) => const SupportChatScreen(),
          '/select-gig-type': (context) => const GigTypeSelectionPage(),
          '/map-page': (context) => const ScrubMapPage(),
          '/notifications-page': (context) => NotificationsPage(),
          '/reset-password': (context) => const ResetPasswordPage(),
          '/terms-of-service-page': (context) => const TermsOfServicePage()
        },
        builder: (context, child) {
          return InheritedThemeWrapper(
            isDarkMode: _isDarkMode,
            toggleTheme: _toggleTheme,
            child: child!,
          );
        }
    );
  }
}
