import 'package:banpeittarik/Main/alarm_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Map<String, dynamic>> alarms = [];
  final List<String> alarmSounds = [
    'Default',
    'Gentle',
    'Energetic',
    'Nature',
    'Melodic',
  ];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  // Load alarms from SharedPreferences
  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsString = prefs.getString('alarms');
    final bool hasDefaultsSet = prefs.getBool('has_defaults_set') ?? false;

    if (alarmsString != null) {
      final List<dynamic> decodedAlarms = json.decode(alarmsString);
      setState(() {
        alarms =
            decodedAlarms.map((alarm) {
              // Convert time from string to TimeOfDay
              final timeParts = alarm['time'].split(':');
              final time = TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              );

              return {
                'time': time,
                'label': alarm['label'],
                'enabled': alarm['enabled'],
                'days': List<int>.from(alarm['days']),
                'sound': alarm['sound'],
                'vibrate': alarm['vibrate'],
              };
            }).toList();
      });
    } else if (!hasDefaultsSet) {
      // Create default alarms only once when the app is first used
      setState(() {
        alarms = [
          {
            'time': TimeOfDay(hour: 7, minute: 0),
            'label': 'Alarm mynstep',
            'enabled': true,
            'days': [1, 2, 3, 4, 5], // Weekdays
            'sound': 'Default',
            'vibrate': true,
          },
          {
            'time': TimeOfDay(hour: 13, minute: 30),
            'label': 'Jingkynmaw jingshah',
            'enabled': false,
            'days': [6, 7], // Weekend
            'sound': 'Gentle',
            'vibrate': true,
          },
        ];
      });

      // Save the alarms and mark that defaults have been set
      await _saveAlarms();
      await prefs.setBool('has_defaults_set', true);
    }
    // If hasDefaultsSet is true but alarmsString is null, do nothing (no alarms)
  }

  // Save alarms to SharedPreferences
  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> alarmsToSave =
        alarms.map((alarm) {
          // Convert TimeOfDay to string for storage
          final time = '${alarm['time'].hour}:${alarm['time'].minute}';

          return {
            'time': time,
            'label': alarm['label'],
            'enabled': alarm['enabled'],
            'days': alarm['days'],
            'sound': alarm['sound'],
            'vibrate': alarm['vibrate'],
          };
        }).toList();

    await prefs.setString('alarms', json.encode(alarmsToSave));
  }

  void toggleAlarm(int index, bool value) async {
    setState(() {
      alarms[index]['enabled'] = value;
    });
    await _saveAlarms();
  }

  Future<void> addAlarm() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6A1B9A)),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder:
            (context) => AlarmDetailsDialog(
              initialTime: pickedTime,
              sounds: alarmSounds,
            ),
      );

      if (result != null) {
        setState(() {
          alarms.add({
            'time': pickedTime,
            'label':
                result['label']?.isNotEmpty ?? false
                    ? result['label']!
                    : 'Alarm thymmai',
            'enabled': true,
            'days': result['days'] ?? [1, 2, 3, 4, 5],
            'sound': result['sound'] ?? 'Default',
            'vibrate': result['vibrate'] ?? true,
          });
        });
        await _saveAlarms();
      }
    }
  }

  Future<void> editAlarm(int index) async {
    final alarm = alarms[index];

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: alarm['time'],
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6A1B9A)),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder:
            (context) => AlarmDetailsDialog(
              initialLabel: alarm['label'],
              initialTime: pickedTime,
              initialDays: alarm['days'],
              initialSound: alarm['sound'],
              initialVibrate: alarm['vibrate'],
              sounds: alarmSounds,
            ),
      );

      if (result != null) {
        setState(() {
          alarms[index] = {
            'time': pickedTime,
            'label':
                result['label']?.isNotEmpty ?? false
                    ? result['label']!
                    : alarm['label'],
            'enabled': alarm['enabled'],
            'days': result['days'] ?? alarm['days'],
            'sound': result['sound'] ?? alarm['sound'],
            'vibrate': result['vibrate'] ?? alarm['vibrate'],
          };
        });
        await _saveAlarms();
      }
    }
  }

  void deleteAlarm(int index) async {
    final deletedAlarm = alarms[index];
    setState(() {
      alarms.removeAt(index);
    });
    await _saveAlarms();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${deletedAlarm['label']}'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            setState(() {
              alarms.insert(index, deletedAlarm);
            });
            await _saveAlarms();
          },
        ),
      ),
    );
  }

  // New method to clear all alarms
  void clearAllAlarms() async {
    if (alarms.isEmpty) return;

    final deletedAlarms = List<Map<String, dynamic>>.from(alarms);
    setState(() {
      alarms.clear();
    });
    await _saveAlarms();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All alarms deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            setState(() {
              alarms.addAll(deletedAlarms);
            });
            await _saveAlarms();
          },
        ),
      ),
    );
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String getRepeatText(List<int> days) {
    if (days.length == 7) return 'Daily';
    if (days.length == 5 &&
        days.contains(1) &&
        days.contains(2) &&
        days.contains(3) &&
        days.contains(4) &&
        days.contains(5)) {
      return 'Weekdays';
    }
    if (days.length == 2 && days.contains(6) && days.contains(7)) {
      return 'Weekend';
    }
    return 'Custom';
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
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  if (alarms.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.delete_sweep, color: Colors.grey[700]),
                      onPressed: () => _showClearAllConfirmation(),
                      tooltip: 'Delete all alarms',
                    ),
                ],
              ),
            ),
            Expanded(
              child:
                  alarms.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.alarm_off,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Khlem pat buh alarm',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Khniot uto plus napoh ban buh alarm',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: alarms.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final alarm = alarms[index];
                          final time = formatTime(alarm['time']);
                          final enabled = alarm['enabled'];
                          final repeatText = getRepeatText(alarm['days']);

                          return Dismissible(
                            key: Key('$index-${alarm['time']}'),
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
                            onDismissed: (direction) => deleteAlarm(index),
                            confirmDismiss: (direction) async {
                              HapticFeedback.vibrate();
                              return true;
                            },
                            child: InkWell(
                              onTap: () => editAlarm(index),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color:
                                                  enabled
                                                      ? Colors.green
                                                          .withOpacity(0.2)
                                                      : Colors.grey.withOpacity(
                                                        0.15,
                                                      ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.alarm,
                                              color:
                                                  enabled
                                                      ? Colors.green[800]
                                                      : Colors.grey[600],
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  time,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        enabled
                                                            ? Colors.black
                                                            : Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  alarm['label'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        enabled
                                                            ? Colors.grey[700]
                                                            : Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Transform.scale(
                                            scale: 1.2,
                                            child: Switch(
                                              value: enabled,
                                              onChanged:
                                                  (value) =>
                                                      toggleAlarm(index, value),
                                              activeColor: const Color(
                                                0xFF6A1B9A,
                                              ),
                                              activeTrackColor: const Color(
                                                0xFF6A1B9A,
                                              ).withOpacity(0.3),
                                              inactiveThumbColor:
                                                  Colors.grey[400],
                                              inactiveTrackColor:
                                                  Colors.grey[300],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed:
                                                () => _showDeleteConfirmation(
                                                  index,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.repeat,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            repeatText,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.music_note,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            alarm['sound'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                          if (alarm['vibrate']) ...[
                                            const SizedBox(width: 16),
                                            Icon(
                                              Icons.vibration,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Vibrate',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addAlarm,
        icon: const Icon(Icons.add_alarm, color: Colors.white),
        label: const Text(
          'Buh Alarm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6A1B9A),
        elevation: 6,
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Weng alarm',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Phi thikna ban weng noh kane ${alarms[index]['label']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Em'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAlarm(index);
              },
              child: const Text('Haoid', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Alarms'),
          content: const Text('Are you sure you want to delete all alarms?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                clearAllAlarms();
              },
              child: const Text(
                'Delete All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
