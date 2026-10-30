import 'package:flutter/material.dart';

class SurahDetailScreen extends StatelessWidget {
  final String surahName;

  const SurahDetailScreen({Key? key, required this.surahName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // البسملة الجميلة في أعلى السورة (باستثناء سورة التوبة)
            if (surahName != 'سورة التوبة')
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    fontFamily: 'Amiri', // خط عربي جمالي إن وجد
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // مساحة لعرض الآيات مستقبلاً
            Expanded(
              child: Center(
                child: Text(
                  'جاري تحميل آيات $surahName...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
