import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Map<String, dynamic>> alarms = [
    {'time': '07:00 AM', 'label': 'Morning Alarm', 'enabled': true},
    {'time': '01:30 PM', 'label': 'Lunch Reminder', 'enabled': false},
    {'time': '06:00 PM', 'label': 'Workout Time', 'enabled': true},
  ];

  void toggleAlarm(int index, bool value) {
    setState(() {
      alarms[index]['enabled'] = value;
    });
  }

  void addAlarm() {
    // TODO: Implement actual alarm picker logic
    setState(() {
      alarms.add({'time': '08:00 AM', 'label': 'New Alarm', 'enabled': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Alarm jong phi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: alarms.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return ListTile(
                    leading: const Icon(Icons.alarm, color: Colors.indigo),
                    title: Text(
                      alarm['time'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(alarm['label']),
                    trailing: Switch(
                      value: alarm['enabled'],
                      onChanged: (value) => toggleAlarm(index, value),
                    ),
                    tileColor:
                        alarm['enabled']
                            ? Colors.indigo.withOpacity(0.05)
                            : Colors.transparent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addAlarm,
        icon: const Icon(Icons.add_alarm),
        label: const Text("Buh Alarm"),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
