import 'package:flutter/material.dart';
import 'surah_detail_screen.dart';
import 'quran_data.dart'; // أو قائمة السور لديك

class QuickJumpScreen extends StatefulWidget {
  const QuickJumpScreen({Key? key}) : super(key: key);

  @override
  _QuickJumpScreenState createState() => _QuickJumpScreenState();
}

class _QuickJumpScreenState extends State<QuickJumpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // تصفية السور بناءً على ما يكتبه المستخدم في البحث السريع
    final filteredSurahs = QuranData.surahsWithAyat.where((surah) {
      final name = surah['name'].toString();
      return name.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الانتقال السريع'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل البحث للانتقال السريع بالسورة
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'اكتب اسم السورة للانتقال الفوري...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اختر السورة للانتقال المباشر:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            // قائمة النتائج المطابقة للبحث السريع
            Expanded(
              child: ListView.builder(
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  final surah = filteredSurahs[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        surah['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('النوع: ${surah['type']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green),
                      onTap: () {
                        // الانتقال مباشرة إلى شاشة تفاصيل السورة المحددة
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahDetailScreen(surahName: surah['name']),
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
      ),
    );
  }
}
