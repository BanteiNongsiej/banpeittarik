import 'package:flutter/material.dart';
import 'package:banpeittarik/Widget/tarik_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: TarikDrawer(
        onItemSelected: (index) {
          Navigator.pop(context); // Close drawer
          Navigator.pop(context); // Exit settings screen to dashboard
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Ka Settings',
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Ka App'),
          _buildSettingTile(
            icon: Icons.language,
            title: 'Jingkylla ktien',
            subtitle: 'English / Khasi',
            onTap: () => showCenteredSnackBar(context, 'Pat leh eiei kane'),
          ),
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Ki Jingpyntip',
            subtitle: 'On / Off jingpyntip',
            onTap: () => showCenteredSnackBar(context, 'Pat leh eiei kane'),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Ka Akhant'),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Pyn kylla password',
            subtitle: 'Tyllun password thymmai',
            onTap: () => showCenteredSnackBar(context, 'Pat leh eiei kane'),
          ),
          _buildSettingTile(
            icon: Icons.delete_forever,
            title: 'Pynkut noh ia ka akhant',
            subtitle: 'Delete permanently',
            onTap: () => showCenteredSnackBar(context, 'Pat leh eiei kane'),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Kiwei kiwei'),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Ka Jingiarap',
            subtitle: 'FAQ bad jingkyrshan',
            onTap: () => showCenteredSnackBar(context, 'Pat leh eiei kane'),
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Shaphang ka App',
            subtitle: 'Version 1.0.0',
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: const Color.fromARGB(255, 117, 115, 115)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

/// 🔁 Reusable SnackBar Function
void showCenteredSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.grey[900],
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
