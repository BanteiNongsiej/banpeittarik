import 'package:flutter/material.dart';

class AlarmDetailsDialog extends StatefulWidget {
  final String? initialLabel;
  final TimeOfDay initialTime;
  final List<int>? initialDays;
  final String? initialSound;
  final bool? initialVibrate;
  final List<String> sounds;

  const AlarmDetailsDialog({
    super.key,
    this.initialLabel,
    required this.initialTime,
    this.initialDays,
    this.initialSound,
    this.initialVibrate,
    required this.sounds,
  });

  @override
  State<AlarmDetailsDialog> createState() => _AlarmDetailsDialogState();
}

class _AlarmDetailsDialogState extends State<AlarmDetailsDialog> {
  late TextEditingController _labelController;
  late List<int> _selectedDays;
  late String _selectedSound;
  late bool _vibrate;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.initialLabel ?? '');
    _selectedDays = widget.initialDays ?? [1, 2, 3, 4, 5];
    _selectedSound = widget.initialSound ?? 'Default';
    _vibrate = widget.initialVibrate ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Kham bniah shapang ka alarm',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Label',
                border: OutlineInputBorder(),
                hintText: 'Enter alarm name',
              ),
              maxLength: 20,
            ),
            const SizedBox(height: 16),
            const Text(
              'Repeat on:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(7, (index) {
                final dayNames = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ];
                return FilterChip(
                  label: Text(dayNames[index]),
                  selected: _selectedDays.contains(index + 1),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(index + 1);
                      } else {
                        _selectedDays.remove(index + 1);
                      }
                      _selectedDays.sort();
                    });
                  },
                  selectedColor: const Color(0xFF6A1B9A).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF6A1B9A),
                );
              }),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSound,
              items:
                  widget.sounds
                      .map(
                        (sound) =>
                            DropdownMenuItem(value: sound, child: Text(sound)),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSound = value;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Sound',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Vibration'),
              value: _vibrate,
              onChanged: (value) {
                setState(() {
                  _vibrate = value;
                });
              },
              activeColor: const Color.fromARGB(255, 133, 59, 179),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'label': _labelController.text,
              'days': _selectedDays,
              'sound': _selectedSound,
              'vibrate': _vibrate,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 159, 89, 202),
          ),
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
