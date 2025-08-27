import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final int _centerYear = DateTime.now().year;
  final int _centerMonth = DateTime.now().month;

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

  // Holiday data - map of month to day to holiday name
  final Map<int, Map<int, String>> _holidays = {
    1: {1: 'New Year', 26: 'Republic Day'},
    2: {},
    3: {14: 'Holi', 31: 'Id-ul-Fitr'},
    4: {14: 'Ambedkar Jayanti', 18: 'Good Friday'},
    5: {12: 'Buddha Purnima'},
    6: {7: 'Bakrid'},
    7: {6: 'Muharram', 14: 'Behdienkhlam', 17: 'Tirot Sing'},
    8: {15: 'Independence Day'},
    9: {},
    10: {2: 'Gandhi Jayanti', 20: 'Diwali', 23: 'Durga Puja'},
    11: {2: 'All Soul\'s Day', 5: 'Guru Nanak', 7: 'Wangala', 23: 'Send Kut'},
    12: {
      12: 'Togan Sangma',
      18: 'Soso Tham',
      25: 'Christmas',
      30: 'Kiang Nangbah',
    },
  };

  // Day names
  final List<String> _dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    final now = DateTime.now();
    // Calculate the index of the current month in our list
    final currentMonthIndex = 1000; // The center is always the current month

    _scrollController.jumpTo(currentMonthIndex * 440.0);
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);

    // Find the first day of the grid (Monday of the week containing the 1st)
    final firstDayOfGrid = first.subtract(Duration(days: first.weekday - 1));

    // We always show 6 weeks for consistency
    final daysInGrid = 42; // 6 weeks * 7 days
    final lastDayOfGrid = firstDayOfGrid.add(Duration(days: daysInGrid - 1));

    final days = <DateTime>[];
    var current = firstDayOfGrid;

    while (current.isBefore(lastDayOfGrid) ||
        current.isAtSameMomentAs(lastDayOfGrid)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return now.year == day.year && now.month == day.month && now.day == day.day;
  }

  void _showAddNotificationDialog(DateTime selectedDate) {
    final TextEditingController _controller = TextEditingController();
    final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.blue,
                size: 40,
              ),
              const SizedBox(height: 10),
              const Text(
                'Buh jing pynkynmaw',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tarik: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Thoh ka jing pynkynmaw jong phi hangne...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    _errorMessage.value = null;
                  }
                },
              ),
              const SizedBox(height: 6),
              ValueListenableBuilder<String?>(
                valueListenable: _errorMessage,
                builder: (context, errorText, child) {
                  return errorText == null
                      ? const SizedBox.shrink()
                      : Text(
                        errorText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                },
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text(
                'Ap Shwa',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                if (_controller.text.trim().isEmpty) {
                  _errorMessage.value = "Phi hap ban thoh eiei.";
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green[700],
                    content: Text(
                      'Jing pynkynmaw lah buh ha tarik ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Buh noh',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          cacheExtent: 2000,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Create an infinite scroll in both directions
                  // index 1000 is the center month (current month)
                  final monthOffset = index - 1000;
                  final year = _centerYear + (monthOffset ~/ 12);
                  int month = _centerMonth + (monthOffset % 12);

                  // Adjust year and month if month is out of bounds
                  int adjustedYear = year;
                  int adjustedMonth = month;

                  if (month > 12) {
                    adjustedYear = year + ((month - 1) ~/ 12);
                    adjustedMonth = ((month - 1) % 12) + 1;
                  } else if (month < 1) {
                    adjustedYear = year - ((1 - month) ~/ 12) - 1;
                    adjustedMonth = 12 - ((1 - month) % 12);
                  }

                  final monthDateTime = DateTime(
                    adjustedYear,
                    adjustedMonth,
                    1,
                  );
                  final monthDays = _getDaysInMonth(monthDateTime);
                  final monthWeeks = <List<DateTime>>[];

                  for (var i = 0; i < monthDays.length; i += 7) {
                    monthWeeks.add(monthDays.sublist(i, i + 7));
                  }

                  final String monthEnglish =
                      _monthNames[adjustedMonth]!['english']!;
                  final String monthKhasi =
                      _monthNames[adjustedMonth]!['khasi']!;

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
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    key: ValueKey('$adjustedYear-$adjustedMonth'),
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
                                    '$monthEnglish/$monthKhasi',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    adjustedYear.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (_isSameMonth(monthDateTime, DateTime.now()))
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

                          // Day names header
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children:
                                  _dayNames.map((day) {
                                    return Expanded(
                                      child: Text(
                                        day,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              day == 'Sat' || day == 'Sun'
                                                  ? Colors.red
                                                  : Colors.grey[700],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),

                          // Calendar grid
                          Column(
                            children:
                                monthWeeks.map((week) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children:
                                          week.map((day) {
                                            final isCurrentMonth =
                                                day.month == adjustedMonth;
                                            final isSelected = _isSameDay(
                                              day,
                                              _selectedDay,
                                            );
                                            final isToday = _isToday(day);
                                            final holiday =
                                                _holidays[day.month]?[day.day];

                                            return Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedDay = day;
                                                  });
                                                  _showAddNotificationDialog(
                                                    day,
                                                  );
                                                },
                                                onLongPress: () {
                                                  _showAddNotificationDialog(
                                                    day,
                                                  );
                                                },
                                                child: Container(
                                                  height: 40,
                                                  margin: const EdgeInsets.all(
                                                    2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isSelected
                                                            ? const Color(
                                                              0xFF6A1B9A,
                                                            )
                                                            : isToday
                                                            ? Colors.blue[300]
                                                            : Colors
                                                                .transparent,
                                                    shape: BoxShape.circle,
                                                    gradient:
                                                        isSelected
                                                            ? const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFF6A1B9A,
                                                                ),
                                                                Color(
                                                                  0xFF8E24AA,
                                                                ),
                                                              ],
                                                              begin:
                                                                  Alignment
                                                                      .topLeft,
                                                              end:
                                                                  Alignment
                                                                      .bottomRight,
                                                            )
                                                            : null,
                                                    boxShadow:
                                                        isSelected
                                                            ? [
                                                              BoxShadow(
                                                                color: const Color(
                                                                  0xFF6A1B9A,
                                                                ).withOpacity(
                                                                  0.4,
                                                                ),
                                                                blurRadius: 8,
                                                                spreadRadius: 2,
                                                              ),
                                                            ]
                                                            : null,
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Text(
                                                        day.day.toString(),
                                                        style: TextStyle(
                                                          color:
                                                              isSelected
                                                                  ? Colors.white
                                                                  : !isCurrentMonth
                                                                  ? Colors
                                                                      .grey[400]
                                                                  : day.weekday ==
                                                                          6 ||
                                                                      day.weekday ==
                                                                          7
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .grey[800],
                                                          fontWeight:
                                                              isSelected ||
                                                                      isToday
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                        ),
                                                      ),
                                                      if (holiday != null &&
                                                          isCurrentMonth)
                                                        Positioned(
                                                          bottom: 0,
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                  maxWidth: 36,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 2,
                                                                  vertical: 1,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors
                                                                      .red[50],
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              holiday,
                                                              style: const TextStyle(
                                                                fontSize: 8,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount:
                    2000, // 1000 months in each direction (about 83 years)
                addAutomaticKeepAlives: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToCurrentMonth,
        backgroundColor: Colors.blue,
        elevation: 4,
        child: const Icon(Icons.today, color: Colors.white),
      ),
    );
  }
}
