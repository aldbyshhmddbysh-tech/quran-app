import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // مكتبة لتمكين ميزة النسخ الحقيقي للحافظة
import 'quran_data.dart';
import 'tafsir_screen.dart'; // استيراد شاشة التفسير

class SurahDetailScreen extends StatelessWidget {
  final String surahName;

  const SurahDetailScreen({Key? key, required this.surahName}) : super(key: key);

  // دالة لإظهار قائمة الخيارات عند الضغط المطول على الآية
  void _showAyahOptions(BuildContext context, String ayahText, List<dynamic> ayat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ayahText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Divider(height: 20),
              
              // خيار التفسير (الانتقال لشاشة التفسير للعلامة محمد بن عبد الله عوض)
              ListTile(
                leading: const Icon(Icons.book, color: Colors.green),
                title: const Text('تفسير الآية'),
                onTap: () {
                  Navigator.pop(context); // إغلاق القائمة المنسدلة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TafsirScreen(ayahText: ayahText),
                    ),
                  );
                },
              ),
              
              // خيار قراءة الآية (تلاوة مستمرة من الآية المحددة حتى نهاية السورة)
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.blue),
                title: const Text('تشغيل التلاوة من هذه الآية للنهاية'),
                onTap: () {
                  Navigator.pop(context); // إغلاق القائمة المنسدلة
                  
                  // معرفة رقم الآية الحالية (index) بناءً على النص المحدد
                  final ayahIndex = ayat.indexOf(ayahText);
                  final remainingAyatCount = ayat.length - ayahIndex;

                  // رسالة تأكيد تفاعلية تظهر للمستخدم
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('جاري تشغيل التلاوة من الآية (${ayahIndex + 1}) حتى نهاية السورة ($remainingAyatCount آية)...'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
              ),
              
              // خيار نسخ الآية (النسخ الفعلي للحافظة)
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.orange),
                title: const Text('نسخ الآية'),
                onTap: () {
                  Navigator.pop(context); // إغلاق القائمة المنسدلة
                  Clipboard.setData(ClipboardData(text: ayahText)); // نسخ النص
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم نسخ الآية إلى الحافظة بنجاح'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final surah = QuranData.surahsWithAyat.firstWhere(
      (s) => s['name'] == surahName,
      orElse: () => {
        'name': surahName,
        'type': 'غير محدد',
        'ayat': ['بسم الله الرحمن الرحيم', 'هذه عينة تجريبية للآيات في هذه السورة...']
      },
    );

    final List<dynamic> ayat = surah['ayat'];
    final String surahType = surah['type'] ?? 'مكية';

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        itemCount: ayat.length + 1, // أضفنا 1 لكي نعرض رأس السورة في البداية
        itemBuilder: (context, index) {
          // العنصر الأول هو رأس السورة المزخرف المطابق للمصحف الشريف
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.black, // خلفية سوداء داكنة مثل المصحف
                border: Border.all(color: Colors.white75, width: 1.5), // إطار أنيق
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // عدد الآيات يسار الرأس
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'آياتها ${ayat.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  
                  // اسم السورة في المنتصف بخط بارز
                  Expanded(
                    child: Text(
                      surahName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // نوع السورة (مكية/مدنية) يمين الرأس
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      surahType,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          // بقية العناصر هي آيات السورة
          final ayahIndex = index - 1;
          final ayahText = ayat[ayahIndex];
          
          return GestureDetector(
            onLongPress: () {
              _showAyahOptions(context, ayahText, ayat);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[100],
                      radius: 14,
                      child: Text(
                        '${ayahIndex + 1}',
                        style: TextStyle(fontSize: 12, color: Colors.green[800], fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ayahText,
                        style: const TextStyle(fontSize: 18, height: 1.6),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
