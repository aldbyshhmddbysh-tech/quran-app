import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SettingsScreen({
    Key? key,
    required this.onThemeChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 20.0; // حجم خط الآيات الافتراضي

  @override
  Widget build(BuildContext context) {
    // الألوان المتناسقة مع هوية التطبيق التراثية (وضع ليلي أو نهاري)
    final backgroundColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFE8DCC4);
    final cardColor = widget.isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF3EED9);
    final textColor = widget.isDarkMode ? Colors.white : const Color(0xFF2C2C2C);
    const primaryColor = Color(0xFF5A6B48);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'إِعْدَادَاتُ التَّطْبِيقِ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // قسم مظهر التطبيق (الوضع الليلي / القراءة الليلية)
          Text(
            'مظهر القراءة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: cardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: primaryColor, width: 1.5),
            ),
            child: SwitchListTile(
              secondary: Icon(
                widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                color: primaryColor,
              ),
              title: Text(
                'الوضع الليلي (القراءة الليلية)',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              subtitle: Text(
                widget.isDarkMode ? 'الخلفية داكنة مريحة للعين' : 'الوضع التراثي الفاتح',
                style: TextStyle(color: widget.isDarkMode ? Colors.white70 : const Color(0xFF6C6C6C)),
              ),
              value: widget.isDarkMode,
              activeColor: primaryColor,
              onChanged: (bool value) {
                widget.onThemeChanged(value); // تغيير الثيم فوراً
              },
            ),
          ),
          const SizedBox(height: 24),

          // قسم حجم الخط للآيات القرآنية
          Text(
            'حجم الخط القرآني',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: cardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: primaryColor, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الصغير', style: TextStyle(color: textColor)),
                      Text('${_fontSize.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                      Text('الكبير', style: TextStyle(color: textColor)),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 16.0,
                    max: 36.0,
                    divisions: 10,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withOpacity(0.3),
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
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
