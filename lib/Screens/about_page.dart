import 'package:flutter/material.dart';
import 'package:banpeittarik/Widget/tarik_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TarikDrawer(
        onItemSelected: (index) {
          Navigator.pop(context); // Close drawer
          Navigator.pop(context); // Exit About screen to dashboard
        },
      ),
      backgroundColor: const Color(0xFFe0eafc),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFcfdef3),
        elevation: 0,
        title: const Text(
          'Shaphang ka App',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: const [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(
                  'assets/images/Ban_Peit_Tarik_Logo.png',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ban Peit Tarik',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2c3e50),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Ka Ban Peit Tarik ka dei ka app ba la thaw ban iarap ia phi ban kynmaw ia ki sngi kha, '
              'ki kam ba donkam, bad ki jingpyntip bapher bapher. Ka app ka pyndonkam da ka kalendar, '
              'ka alarm, bad ki jingpyntip ba la buh lypa ban pynkynmaw kham kloi.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ki Kamram Jong Ka App:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Text(
              '• Peit ia ka kalendar bad ki sngi ba donkam.\n'
              '• Thoh bad buh ia ki jingkynmaw ha ka tarik.\n'
              '• Pynset alarm ban ioh jingkynmaw ha ka por ba biang.\n'
              '• Pdiang ki jingpyntip shaphang ki kam ba dang sah.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
