import 'package:flutter/material.dart';
import 'package:banpeittarik/Widget/tarik_drawer.dart';

class HolidaysList extends StatelessWidget {
  const HolidaysList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: TarikDrawer(
        onItemSelected: (index) {
          Navigator.pop(context); // Close drawer
          Navigator.pop(context); // Exit Holidays screen to dashboard
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 3,
                spreadRadius: 0.5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Ki Sngi Shuti',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            HolidayCard(
              monthKhasi: 'January/Kyllalyngkot',
              holidays: [
                '1 tarik - New Year (Snem Thymmai)',
                '26 tarik – Republic Day',
              ],
            ),
            HolidayCard(
              monthKhasi: 'February/Rymphang',
              holidays: ['No holiday declared publicly yet.'],
            ),
            HolidayCard(
              monthKhasi: 'March/Lber',
              holidays: ['14 tarik - Holi', '31 tarik - Id-ul-Fitr'],
            ),
            HolidayCard(
              monthKhasi: 'April/Ïaiong',
              holidays: [
                '14 tarik – Dr. B.R. Ambedkar Jayanti',
                '18 tarik – Good Friday',
              ],
            ),
            HolidayCard(
              monthKhasi: 'May/Jymmang',
              holidays: ['12 tarik – Buddha Purnima'],
            ),
            HolidayCard(
              monthKhasi: 'June/Jylliew',
              holidays: ['7 tarik – Id-ul-Zuha (Bakrid)'],
            ),
            HolidayCard(
              monthKhasi: 'July/Naitung',
              holidays: [
                '6 tarik - Muharram',
                '14 tarik - Behdienkhlam',
                '17 tarik - Death anniversary of U Tirot Sing',
              ],
            ),
            HolidayCard(
              monthKhasi: 'August/Nailar',
              holidays: ['15 tarik – Independence Day'],
            ),
            HolidayCard(
              monthKhasi: 'September/Nailur',
              holidays: ['No holiday declared publicly yet.'],
            ),
            HolidayCard(
              monthKhasi: 'October/Risaw',
              holidays: [
                '2 tarik - Mahatma Gandhi\'s Birthday',
                '20 tarik - Diwali',
                '23 tarik – Durga Puja',
              ],
            ),
            HolidayCard(
              monthKhasi: 'November/Naiwieng',
              holidays: [
                '2 tarik - All Soul\'s Day',
                '5 tarik - Guru Nanak\'s Birthday',
                '7 tarik - Wangala Festival',
                '23 tarik - Send Kut Snem',
              ],
            ),
            HolidayCard(
              monthKhasi: 'December/Nohprah',
              holidays: [
                '12 tarik - Death Anniversary of Pa Togan Nengminja Sangma',
                '18 tarik - Death Anniversary of U Soso Tham',
                '25 tarik – Christmas Day',
                '30 tarik – Death Anniversary of U Kiang Nangbah',
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Note: Kane ka long tang ka jingbatai kum ka nuksa, ym pat pyllait paidbah ki tarik lut baroh.',
              style: TextStyle(
                color: Color.fromARGB(255, 94, 87, 87),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class HolidayCard extends StatelessWidget {
  final String monthKhasi;
  final List<String> holidays;

  const HolidayCard({
    super.key,
    required this.monthKhasi,
    required this.holidays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ki sngi shuti hapoh u $monthKhasi:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...holidays.map(
            (event) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 85, 77, 77),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
