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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التطبيق'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // قسم مظهر التطبيق (الوضع الليلي / القراءة الليلية)
          const Text(
            'مظهر القراءة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: Icon(
                widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                color: widget.isDarkMode ? Colors.blueAccent : Colors.orange,
              ),
              title: const Text(
                'الوضع الليلي (القراءة الليلية)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.isDarkMode ? 'الخلفية داكنة مريحة للعين' : 'الوضع الفاتح العادي',
              ),
              value: widget.isDarkMode,
              onChanged: (bool value) {
                widget.onThemeChanged(value); // تغيير الثيم فوراً
              },
            ),
          ),
          const SizedBox(height: 24),

          // قسم حجم الخط للآيات القرآنية
          const Text(
            'حجم الخط القرآني',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الصغير'),
                      Text('${_fontSize.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text('الكبير'),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 16.0,
                    max: 36.0,
                    divisions: 10,
                    activeColor: Colors.green[750],
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      style: TextStyle(fontSize: _fontSize, fontFamily: 'Amiri', fontWeight: FontWeight.bold),
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
