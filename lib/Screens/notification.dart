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
      'read': false,
    },
    {
      'title': 'Buh Alarm noh',
      'message': 'Alarm jong lashai ka dang on moa.',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'icon': Icons.alarm_on,
      'read': true,
    },
    {
      'title': 'Ka kam ban pyndep',
      'message': 'Phin hap pyndep noh hapoh la shi sngi kane te.',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.warning_amber,
      'read': true,
    },
  ];

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min kham shuwa';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour kham shuwa';
    } else {
      return DateFormat('MMM d, h:mm a').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Text(
                    'Jing Pyntip',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  notifications.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Pat don jing pynkynmaw eiei.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final notif = notifications[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      notif['read']
                                          ? Colors.grey[200]
                                          : Colors.orange.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  notif['icon'],
                                  size: 24,
                                  color:
                                      notif['read']
                                          ? Colors.grey[600]
                                          : Colors.deepOrange,
                                ),
                              ),
                              title: Text(
                                notif['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                notif['message'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Text(
                                formatTime(notif['time']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              onTap: () {
                                setState(() {
                                  notifications[index]['read'] = true;
                                });
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
