import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _firstMonth = DateTime.utc(2024, 1, 1);
  final DateTime _lastMonth = DateTime.utc(2026, 12, 1);
  DateTime _selectedDay = DateTime.now();

  final ScrollController _scrollController = ScrollController();
  final double _estimatedMonthHeight = 440; // Approx height per calendar

  @override
  void initState() {
    super.initState();
    // Delay to wait until first frame builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    final now = DateTime.now();
    final int index =
        (now.year - _firstMonth.year) * 12 + (now.month - _firstMonth.month);
    final double offset = index * _estimatedMonthHeight;
    _scrollController.jumpTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int monthCount =
        (_lastMonth.year - _firstMonth.year) * 12 +
        _lastMonth.month -
        _firstMonth.month +
        1;

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: monthCount,
          itemBuilder: (context, index) {
            final year =
                _firstMonth.year + ((index + _firstMonth.month - 1) ~/ 12);
            final month = ((index + _firstMonth.month - 1) % 12) + 1;
            final DateTime monthStart = DateTime(year, month);

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(monthStart),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: monthStart,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
