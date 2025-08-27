import 'package:flutter/material.dart';
import 'package:banpeittarik/Widget/tarik_drawer.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _expandedDescription = false;
  bool _expandedFeatures = false;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'alert':
        return Colors.red[600]!;
      case 'alarm':
        return Colors.purple[600]!;
      case 'reminder':
        return Colors.orange[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final primaryColor = _getTypeColor('alarm'); // Using reminder color scheme

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      drawer: TarikDrawer(
        onItemSelected: (index) {
          Navigator.pop(context); // Close drawer
          Navigator.pop(context); // Exit About screen to dashboard
        },
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Shaphang ka App',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [Colors.blueGrey[800]!, Colors.grey[900]!]
                      : [Colors.blue[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(
              tag: 'app-logo',
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      'assets/images/Ban_Peit_Tarik_Logo.png',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Peit Tarik',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // App Description Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ka Peit Tarik App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ka Peit Tarik App ka dei ka app ba la thaw ban iarap ia phi ban kynmaw ia ki sngi kha, kiei kiei kiba donkam ban pyn kynmaw ia phi ia ki kam ba phi leh man ka sngi, '
                      'ki kam ba donkam, bad ki jingpyntip bapher bapher...',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        height: 1.6,
                      ),
                      maxLines: _expandedDescription ? null : 3,
                      overflow:
                          _expandedDescription
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _expandedDescription = !_expandedDescription;
                        });
                      },
                      child: Text(
                        _expandedDescription ? 'Peit Khyndiat' : 'Peit lut',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: cardColor,
              child: ExpansionTile(
                initiallyExpanded: true,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedFeatures = expanded;
                  });
                },
                title: Text(
                  'Ki Kamram Jong Ka App:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
                children: [
                  _buildFeatureItem(
                    'Peit ia ka kalendar bad ki sngi ba donkam',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    'Thoh bad buh ia ki jingkynmaw ha ka tarik',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    'Pynset alarm ban ioh jingkynmaw ha ka por ba biang',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    'Pdiang ki jingpyntip shaphang ki kam ba dang sah',
                    isDarkMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Developer Info - Updated to match notification colors
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'U Nongshna',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/developer_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Banteilang Nongsiej",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Bahdeng ba na shnong Pongkung",
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.code, color: primaryColor),
                      ),
                      title: Text(
                        'Peit Tarik',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        // Instagram Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF405DE6),
                                Color(0xFF5851DB),
                                Color(0xFF833AB4),
                                Color(0xFFC13584),
                                Color(0xFFE1306C),
                                Color(0xFFFD1D1D),
                                Color(0xFFF56040),
                                Color(0xFFF77737),
                                Color(0xFFFCAF45),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap:
                                  () => _launchURL(
                                    "https://www.instagram.com/bantei_nongsiej02/",
                                  ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Facebook Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1877F2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap:
                                  () => _launchURL(
                                    "https://www.facebook.com/bantei.nongsiej.35/",
                                  ),
                              child: const Center(
                                child: Icon(
                                  Icons.facebook,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Email Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap:
                                  () => _launchURL(
                                    'mailto:support@banpeittarik.com',
                                  ),
                              child: const Center(
                                child: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Website Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap:
                                  () => _launchURL('https://banpeittarik.com'),
                              child: const Center(
                                child: Icon(
                                  Icons.language,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Rate App Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                // Implement rate app functionality
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDarkMode) {
    final primaryColor = _getTypeColor('reminder');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 8.0),
            child: Icon(Icons.check_circle, size: 20, color: primaryColor),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
