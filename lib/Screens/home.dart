import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _firstMonth = DateTime.utc(1980, 1, 1);
  final DateTime _lastMonth = DateTime.utc(DateTime.now().year + 100, 12, 1);

  DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay; // Will be initialized in initState

  final ScrollController _scrollController = ScrollController();
  final double _estimatedMonthHeight = 440;

  // English and Khasi month names mapping
  final Map<int, Map<String, String>> _monthNames = {
    1: {'english': 'January', 'khasi': 'Kyllalyngkot'},
    2: {'english': 'February', 'khasi': 'Rymphang'},
    3: {'english': 'March', 'khasi': 'Lber'},
    4: {'english': 'April', 'khasi': 'Ïaiong'},
    5: {'english': 'May', 'khasi': 'Jymmang'},
    6: {'english': 'June', 'khasi': 'Jylliew'},
    7: {'english': 'July', 'khasi': 'Naitung'},
    8: {'english': 'August', 'khasi': 'Nailar'},
    9: {'english': 'September', 'khasi': 'Nailur'},
    10: {'english': 'October', 'khasi': 'Risaw'},
    11: {'english': 'November', 'khasi': 'Naiwieng'},
    12: {'english': 'December', 'khasi': 'Nohprah'},
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToCurrentMonth();
      });
    });
  }

  void _scrollToCurrentMonth() {
    final now = DateTime.now();
    final index = (now.year - _firstMonth.year) * 12 + (now.month - 1);
    final offset = index * _estimatedMonthHeight;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
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
      backgroundColor: Colors.grey[100], // Light grey background
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final year =
                    _firstMonth.year + ((index + _firstMonth.month - 1) ~/ 12);
                final month = ((index + _firstMonth.month - 1) % 12) + 1;
                final DateTime monthStart = DateTime(year, month, 1);
                final DateTime monthEnd = DateTime(
                  year,
                  month + 1,
                  0,
                ); // Last day of month

                // Ensure focusedDay is within the current month's range
                final DateTime currentMonthFocusedDay =
                    _focusedDay.isBefore(monthStart)
                        ? monthStart
                        : _focusedDay.isAfter(monthEnd)
                        ? monthEnd
                        : _focusedDay;

                // Get bilingual month name
                final String englishMonth = _monthNames[month]!['english']!;
                final String khasiMonth = _monthNames[month]!['khasi']!;
                final String monthDisplay = '$englishMonth/$khasiMonth';

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  monthDisplay,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  year.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (isSameMonth(monthStart, DateTime.now()))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Mynta (Current)',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TableCalendar(
                          firstDay: monthStart,
                          lastDay: monthEnd,
                          focusedDay: currentMonthFocusedDay,
                          calendarFormat: CalendarFormat.month,
                          selectedDayPredicate:
                              (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                            _animateToSelectedDay(selectedDay);
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          headerVisible: false,
                          availableGestures: AvailableGestures.none,
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                            weekendTextStyle: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                            outsideTextStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.blue[300],
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6A1B9A), // Deep violet
                                  Color(0xFF8E24AA), // Light violet
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6A1B9A,
                                  ).withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            markersMaxCount: 1,
                            markerDecoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                            weekendStyle: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: monthCount),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToCurrentMonth,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.today, color: Colors.white),
        elevation: 4,
      ),
    );
  }

  void _animateToSelectedDay(DateTime selectedDay) {
    final int index =
        (selectedDay.year - _firstMonth.year) * 12 +
        (selectedDay.month - _firstMonth.month);
    final double offset = index * _estimatedMonthHeight;
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }
}
