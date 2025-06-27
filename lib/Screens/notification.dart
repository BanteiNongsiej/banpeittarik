import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Pynkynmaw sngi kha',
      'message': 'Wat klet sngi kha jong u deng lashai!',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'icon': Icons.cake,
    },
    {
      'title': 'Buh Alarm noh',
      'message': 'Alarm jong lashai ka dang on moa.',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'icon': Icons.alarm_on,
    },
    {
      'title': 'Ka kam ban pyndep',
      'message': 'Phin hap pyndep noh hapoh la shi sngi kane te.',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.warning,
    },
  ];

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            notifications.isEmpty
                ? const Center(
                  child: Text(
                    'Pat don jing pynkynmaw eiei.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return ListTile(
                      leading: Icon(notif['icon'], color: Colors.indigo),
                      title: Text(
                        notif['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notif['message']),
                      trailing: Text(
                        formatTime(notif['time']),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.indigo.withOpacity(0.04),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
