import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final String surahName;

  const SurahDetailScreen({Key? key, required this.surahName}) : super(key: key);

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  // قائمة تجريبية للآيات (يمكن ربطها بملف quran_data.dart لاحقاً)
  final List<String> ayahs = [
    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
    "الرَّحْمَٰنِ الرَّحِيمِ",
    "مَالِكِ يَوْمِ الدِّينِ",
    "إيَّاكَ نَعْبُدُ وَإيَّاكَ نَسْتَعِينُ",
    "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
    "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                title: Text(
                  "${ayahs[index]} (${index + 1})",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'QuranFont', // يمكنك تخصيص الخط لاحقاً
                    fontWeight: FontWeight.w600,
                    height: 1.8,
                  ),
                ),
                onLongPress: () {
                  // قائمة خيارات عند الضغط المطول على الآية (تفسير، حفظ، تلاوة)
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.book, color: Colors.green),
                            title: const Text('تفسير الآية'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('فتح التفسير')),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.bookmark, color: Colors.blue),
                            title: const Text('إضافة علامة مرجعية'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت إضافة العلامة المرجعية')),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.copy, color: Colors.orange),
                            title: const Text('نسخ الآية'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم نسخ الآية')),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
