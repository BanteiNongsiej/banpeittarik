import 'package:flutter/material.dart';

class TarikDrawer extends StatelessWidget {
  final void Function(int) onItemSelected;

  const TarikDrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF89f7fe), Color(0xFF66a6ff)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: const Text(
                'Ban Peit Tarik',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              accountEmail: const Text(
                'Testing',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              currentAccountPicture: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  'assets/images/Ban_Peit_Tarik_Logo.png',
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => onItemSelected(0),
            ),
            _buildDrawerItem(
              icon: Icons.alarm,
              text: 'Alarm',
              onTap: () => onItemSelected(1),
            ),
            _buildDrawerItem(
              icon: Icons.notifications,
              text: 'Notifications',
              onTap: () => onItemSelected(2),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            _buildDrawerItem(
              icon: Icons.info,
              text: 'About',
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Logout',
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey[800]),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      hoverColor: Colors.blueGrey.withOpacity(0.1),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
