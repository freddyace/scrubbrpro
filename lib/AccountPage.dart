import 'package:flutter/material.dart';
import 'package:scrubbrpro/utils/InheritedWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isDarkMode = false;

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
          icon: Icon(Icons.arrow_back, color: Theme.of(context).scaffoldBackgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
              )),
          const Text("jsilva@gmail.com", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),

          _buildSectionHeader("General Settings"),
          _buildToggleTile(Icons.settings, "Dark Mode"),
          _buildSettingsTile(Icons.vpn_key, "Change Password"),

          _buildSectionHeader("Information"),
          _buildSettingsTile(Icons.phone_iphone, "About App"),
          _buildSettingsTile(Icons.description, "Terms & Conditions"),
          _buildSettingsTile(Icons.privacy_tip, "Privacy Policy"),
          _buildSettingsTile(Icons.logout, "Logout"),
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
          color: Theme.of(context).scaffoldBackgroundColor
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, [String? subtitle, Widget? trailing]) {

    return Container(
      child: ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(
          title,
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).scaffoldBackgroundColor
          ),
        )
            : null,
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
        onTap: () {},
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
        onChanged: (value) => InheritedThemeWrapper.of(context).toggleTheme(value),
        activeColor: Colors.green,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

}
