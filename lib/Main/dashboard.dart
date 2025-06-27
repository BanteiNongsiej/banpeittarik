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
    AlarmScreen(),
    NotificationScreen(),
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
        elevation: 0,
        backgroundColor: const Color(
          0xFFcfdef3,
        ), // Matches drawer gradient bottom
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            // const SizedBox(width: 4),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image.asset(
            //     'assets/images/Ban_Peit_Tarik_Logo.png',
            //     height: 36,
            //     width: 36,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // const SizedBox(width: 10),
            const Text(
              'Peit Tarik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF2c3e50), // Dark blue-grey
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
        selectedItemColor: const Color(
          0xFF4b79a1,
        ), // Matches drawer top gradient
        unselectedItemColor: Colors.grey[600],
        backgroundColor: const Color(0xFFe0eafc), // Matches drawer base
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Iing',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clock),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bell),
            label: 'Jing Pyntip',
          ),
        ],
      ),
    );
  }
}
