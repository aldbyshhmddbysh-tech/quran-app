import 'package:flutter/material.dart';
import 'splash_screen.dart'; // استيراد شاشة الترحيب
import 'tasbih_screen.dart'; // 1. استيراد شاشة المسبحة الإلكترونية
import 'quran_screen.dart';
import 'quick_jump_screen.dart';
import 'settings_screen.dart';
import 'audio_recorder_screen.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'قراءة وتفسير أهل البيت (ع)',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFE8DCC4), // لون خلفية تراثي متناسق
      ),
      home: const SplashScreen(), // جعل شاشة البداية بالآية هي أول ما يظهر
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC4),
      body: SafeArea(
        child: Column(
          children: [
            // شريط المعلومات العلوي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'آخر دخول منذ يوم',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
            // قائمة الأزرار المزخرفة
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: [
                    _buildOrnateButton(
                      context,
                      title: 'فتح القرآن',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QuranScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // 2. زر المسبحة الإلكترونية الجديد
                    _buildOrnateButton(
                      context,
                      title: 'المسبحة الإلكترونية',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TasbihScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOrnateButton(
                      context,
                      title: 'البحث في القرآن',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فتح نافذة البحث')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOrnateButton(
                      context,
                      title: 'ذهاب إلى',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QuickJumpScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOrnateButton(
                      context,
                      title: 'العلامات المحفوظة',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('العلامات المحفوظة')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOrnateButton(
                      context,
                      title: 'اضافاتي',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AudioRecorderScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOrnateButton(
                      context,
                      title: 'الإعدادات',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              isDarkMode: false,
                              onThemeChanged: (val) {},
                              selectedReciter: 'الشيخ عبد الباسط عبد الصمد',
                              onReciterChanged: (val) {},
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOrnateButton(
                      context,
                      title: 'عن البرنامج',
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'تطبيق القرآن والأذكار',
                          applicationVersion: '1.0.0',
                          applicationLegalese: 'جميع الحقوق محفوظة',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تصميم الزر المزخرف المحاكي للصورة
  Widget _buildOrnateButton(BuildContext context, {required String title, required VoidCallback onPressed}) {
    return InkWell(
      onPressed: onPressed,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EED9),
          border: Border.all(color: const Color(0xFF5A6B48), width: 1.5),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // الزخرفة على اليمين
            Positioned(
              right: 8,
              child: Icon(Icons.star, size: 18, color: Colors.green[800]),
            ),
            // النص في المنتصف
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            // الزخرفة على اليسار
            Positioned(
              left: 8,
              child: Icon(Icons.star, size: 18, color: Colors.green[800]),
            ),
          ],
        ),
      ),
    );
  }
}
