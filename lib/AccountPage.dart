import 'package:flutter/material.dart';
import 'package:scrubbrpro/AboutAppPage.dart';
import 'package:scrubbrpro/LogoutConfirmationPage.dart';
import 'package:scrubbrpro/PrivacyPolicyPage.dart';
import 'package:scrubbrpro/TermsOfServicePage.dart';
import 'package:scrubbrpro/utils/InheritedWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ResetPasswordPage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isDarkMode = false;
  bool isVerified = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).scaffoldBackgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile',
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage('assets/images/temp/avatar.jpg'),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text("Juliana Silva",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const Text("jsilva@gmail.com", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          _buildSectionHeader("General Settings"),
          _buildToggleTile(Icons.settings, "Dark Mode"),
          _buildSettingsTile(Icons.vpn_key, null, "Change Password", null,
              const Icon(Icons.arrow_forward_ios), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResetPasswordPage()),
            );
          }),
          isVerified ? _buildSettingsTile(Icons.verified_user, Colors.green, "Account Verified") :_buildSettingsTile(Icons.clear_sharp, Colors.red, "Account Verification Needed"),
          _buildSectionHeader("Information"),
          _buildSettingsTile(Icons.phone_iphone, null, "About App", null, null, (){
            Navigator.push((context), MaterialPageRoute(builder: (context) => const AboutAppPage()));
          }),
          _buildSettingsTile(Icons.description, null, "Terms of Service", null, null, (){
            Navigator.push((context), MaterialPageRoute(builder: (context) => const TermsOfServicePage()));
          }),
          _buildSettingsTile(Icons.privacy_tip, null, "Privacy Policy", null, null, (){
            Navigator.push((context), MaterialPageRoute(builder: (context) => const PrivacyPolicyWebView()));
          }),
          _buildSettingsTile(Icons.logout, null, "Logout", null, null, (){
            Navigator.push((context), MaterialPageRoute(builder: (context) => const LogoutConfirmationPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, MaterialColor? leadingIconColor, String title,
      [String? subtitle, Widget? trailing, VoidCallback? onTap]) {
    return Container(
      child: ListTile(
        leading: Icon(icon, color: leadingIconColor),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title) {
    return Container(
      child: SwitchListTile(
        secondary: Icon(
          icon,
        ),
        title: Text(
          title,
        ),
        value: InheritedThemeWrapper.of(context).isDarkMode,
        onChanged: (value) =>
            InheritedThemeWrapper.of(context).toggleTheme(value),
        activeColor: Colors.green,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
