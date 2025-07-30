import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Map<String, dynamic>> alarms = [
    {'time': '07:00 AM', 'label': 'Alarm mynstep', 'enabled': true},
    {'time': '01:30 PM', 'label': 'Jingkynmaw jingshah', 'enabled': false},
    {'time': '06:00 PM', 'label': 'Por exercise', 'enabled': true},
  ];

  void toggleAlarm(int index, bool value) {
    setState(() {
      alarms[index]['enabled'] = value;
    });
  }

  void addAlarm() {
    setState(() {
      alarms.add({
        'time': '08:00 AM',
        'label': 'Alarm thymmai',
        'enabled': true,
      });
    });
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
                    'Ki Alarm jong phi',
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: alarms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              alarm['enabled']
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.alarm,
                          color:
                              alarm['enabled']
                                  ? Colors.green[800]
                                  : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                      title: Text(
                        alarm['time'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              alarm['enabled']
                                  ? Colors.black
                                  : Colors.grey[600],
                        ),
                      ),
                      subtitle: Text(
                        alarm['label'],
                        style: TextStyle(
                          color:
                              alarm['enabled']
                                  ? Colors.grey[700]
                                  : Colors.grey[500],
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: 1.2,
                        child: Switch(
                          value: alarm['enabled'],
                          onChanged: (value) => toggleAlarm(index, value),
                          activeColor: const Color(0xFF6A1B9A),
                          activeTrackColor: const Color(
                            0xFF6A1B9A,
                          ).withOpacity(0.3),
                          inactiveThumbColor: Colors.grey[400],
                          inactiveTrackColor: Colors.grey[300],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addAlarm,
        icon: const Icon(Icons.add_alarm, color: Colors.white),
        label: const Text(
          'Buh Alarm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        elevation: 6,
      ),
    );
  }
}
