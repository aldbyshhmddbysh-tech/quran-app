import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quran_data.dart';
import 'tafsir_screen.dart';

class SurahDetailScreen extends StatelessWidget {
  final String surahName;
  final String selectedReciter;

  const SurahDetailScreen({
    Key? key,
    required this.surahName,
    required this.selectedReciter,
  }) : super(key: key);

  // دالة حفظ الآية في الذاكرة المحلية (العلامات المحفوظة)
  Future<void> _addBookmark(BuildContext context, String ayahText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rawBookmarks = prefs.getStringList('quran_bookmarks_map') ?? [];
    
    // تنسيق العنوان مع اسم السورة
    String bookmarkEntry = '$surahName - $ayahText|||تتمة القراءة';
    
    if (!rawBookmarks.contains(bookmarkEntry)) {
      rawBookmarks.add(bookmarkEntry);
      await prefs.setStringList('quran_bookmarks_map', rawBookmarks);
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة الآية للمرجعيات المحفوظة بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
              ListTile(
                leading: const Icon(Icons.bookmark_add, color: Color(0xFF5A6B48)),
                title: const Text('وضع علامة مرجعية'),
                onTap: () {
                  Navigator.pop(context);
                  _addBookmark(context, ayahText);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.purple),
                title: const Text('إضافة ملاحظة أو تدبر'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book, color: Color(0xFF5A6B48)),
                title: const Text('تفسير الآية'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TafsirScreen(ayahText: ayahText),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.blue),
                title: Text('تشغيل التلاوة بصوت $selectedReciter'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('جاري تشغيل التلاوة بصوت $selectedReciter')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.orange),
                title: const Text('نسخ الآية'),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: ayahText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الآية')),
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
        'ayat': ['بسم الله الرحمن الرحيم', 'عينة تجريبية']
      },
    );

    final List<dynamic> ayat = surah['ayat'];
    final String surahType = surah['type'] ?? 'مكية';

    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC4), // لون التراث المتناسق
      appBar: AppBar(
        title: Text(surahName),
        centerTitle: true,
        backgroundColor: const Color(0xFF5A6B48),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: const Color(0xFFF3EED9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(surahName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                const Text('الجزء الأول', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ayat.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A6B48),
                      border: Border.all(color: Colors.white75, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(4)), child: Text('آياتها ${ayat.length}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                        Expanded(child: Text(surahName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2), textAlign: TextAlign.center)),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(4)), child: Text(surahType, style: const TextStyle(color: Colors.white, fontSize: 12))),
                      ],
                    ),
                  );
                }
                if (index == ayat.length + 1) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF5A6B48)), borderRadius: BorderRadius.circular(20)),
                      child: const Text('صدق الله العلي العظيم', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF5A6B48))),
                    ),
                  );
                }
                final ayahIndex = index - 1;
                final ayahText = ayat[ayahIndex];
                return GestureDetector(
                  onLongPress: () => _showAyahOptions(context, ayahText, ayat),
                  child: Card(
                    color: const Color(0xFFF3EED9),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFF5A6B48), width: 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(backgroundColor: const Color(0xFF5A6B48), radius: 14, child: Text('${ayahIndex + 1}', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                          const SizedBox(width: 12),
                          Expanded(child: Text(ayahText, style: const TextStyle(fontSize: 18, height: 1.6, color: Color(0xFF2C2C2C)), textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
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
