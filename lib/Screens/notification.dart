import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Pynkynmaw sngi kha',
      'message': 'Wat klet sngi kha jong u deng lashai!',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'icon': Icons.cake,
      'read': false,
      'type': 'reminder',
      'expanded': false, // Initialize expanded field
    },
    {
      'title': 'Buh Alarm noh',
      'message':
          'Alarm jong lashai ka dang on moa. Alarm jong lashai ka dang on moa. Alarm jong lashai ka dang on moa.',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'icon': Icons.alarm_on,
      'read': true,
      'type': 'alarm',
      'expanded': false, // Initialize expanded field
    },
    {
      'title': 'Ka kam ban pyndep',
      'message': 'Phin hap pyndep noh hapoh la shi sngi kane te.',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.warning_amber,
      'read': true,
      'type': 'alert',
      'expanded': false, // Initialize expanded field
    },
  ];

  String _formatTime(DateTime time) {
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

  void _markAllAsRead() {
    setState(() {
      for (var notif in notifications) {
        notif['read'] = true;
      }
    });
  }

  void _deleteNotification(int index) {
    final deletedNotif = notifications[index];
    setState(() {
      notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pynkylla "${deletedNotif['title']}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              notifications.insert(index, deletedNotif);
            });
          },
        ),
      ),
    );
  }

  void _toggleExpand(int index) {
    setState(() {
      notifications[index]['expanded'] =
          !(notifications[index]['expanded'] ?? false);
      notifications[index]['read'] = true;
    });
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'alert':
        return Colors.red;
      case 'alarm':
        return Colors.purple;
      case 'reminder':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['read']).length;

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
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: _markAllAsRead,
                      child: Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
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
                          final color = _getNotificationColor(notif['type']);

                          return Dismissible(
                            key: Key('$index-${notif['title']}'),
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed:
                                (direction) => _deleteNotification(index),
                            confirmDismiss: (direction) async {
                              HapticFeedback.vibrate();
                              return true;
                            },
                            child: InkWell(
                              onTap: () => _toggleExpand(index),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
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
                                  border: Border.all(
                                    color:
                                        !(notif['read'] ?? true)
                                            ? color.withOpacity(0.3)
                                            : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              notif['icon'],
                                              size: 24,
                                              color: color,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notif['title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[800],
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  _formatTime(notif['time']),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!(notif['read'] ?? true))
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        notif['message'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                        maxLines:
                                            (notif['expanded'] ?? false)
                                                ? null
                                                : 2,
                                        overflow:
                                            (notif['expanded'] ?? false)
                                                ? null
                                                : TextOverflow.ellipsis,
                                      ),
                                      if ((notif['message'] as String).length >
                                          50)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            (notif['expanded'] ?? false)
                                                ? 'Show less'
                                                : 'Show more',
                                            style: TextStyle(
                                              color: Colors.blue[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
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
