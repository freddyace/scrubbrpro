import 'package:flutter/material.dart';

class AccountPage2 extends StatelessWidget {
  const AccountPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
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
          const Text("Juliana Silva",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("jsilva@gmail.com", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),

          _buildSectionHeader("General Settings"),
          _buildSettingsTile(Icons.settings, "Mode", "Dark & Light",
               Switch(value: false, onChanged: (_) {})),
          _buildSettingsTile(Icons.vpn_key, "Change Password"),
          _buildSettingsTile(Icons.language, "Language"),

          const SizedBox(height: 16),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, [String? subtitle, Widget? trailing]) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
