import 'package:flutter/material.dart';
import 'quran_data.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  // القائمة التي ستتغير حسب البحث (تشمل السور والآيات)
  List> displayedSurahs = [];

  @override
  void initState() {
    super.initState();
    displayedSurahs = QuranData.surahsWithAyat; // في البداية تعرض كل البيانات المتاحة
  }

  // دالة البحث الشامل (في اسم السورة أو في الآيات)
  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedSurahs = QuranData.surahsWithAyat;
      } else {
        displayedSurahs = QuranData.surahsWithAyat.where((surah) {
          // البحث في اسم السورة
          final nameMatch = surah['name'].toString().contains(query);
          
          // البحث في داخل الآيات
          final ayatMatch = (surah['ayat'] as List<dynamic>).any(
            (ayah) => ayah.toString().contains(query),
          );

          return nameMatch || ayatMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم - البحث الشامل'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // شريط البحث المتقدم
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterSurahs,
              decoration: InputDecoration(
                hintText: 'ابحث عن اسم سورة أو كلمة في الآيات...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // قائمة النتائج
          Expanded(
            child: ListView.builder(
              itemCount: displayedSurahs.length,
              itemBuilder: (context, index) {
                final surah = displayedSurahs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Text(
                        '${surah['number']}',
                        style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      surah['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text('النوع: ${surah['type']} | عدد الآيات المتاحة: ${(surah['ayat'] as List).length}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahDetailScreen(
                            surahName: surah['name'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
