import 'package:banpeittarik/Screens/alarm.dart';
import 'package:banpeittarik/Screens/home.dart';
import 'package:banpeittarik/Screens/notification.dart';
import 'package:banpeittarik/Widget/tarik_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AlarmScreen(), // Replace with AlarmPage()
    NotificationScreen(), // Replace with StatsPage()
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TarikDrawer(
        onItemSelected: (index) {
          _onItemTapped(index);
          Navigator.pop(context); // Close the drawer
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(
            //     16.0,
            //   ), // Half of the height/width for a perfect circle
            //   child: Image.asset(
            //     'assets/images/Ban_Peit_Tarik_Logo.png',
            //     fit: BoxFit.cover,
            //     height: 40,
            //     width: 40,
            //   ),
            // ),
            // const SizedBox(width: 10),
            const Text(
              'Peit Tarik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) => setState(() => _currentIndex = index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 21, 48, 202),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey[300],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clock),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bell),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
