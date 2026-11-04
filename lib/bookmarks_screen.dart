import 'package:flutter/material.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  // قائمة تجريبية للعلامات المحفوظة (يمكن ربطها بقاعدة بيانات أو SharedPreferences لاحقاً)
  final List> _bookmarks = [
    {'title': 'سورة البقرة - الآية 255 (آية الكرسي)', 'page': 'الصفحة 42'},
    {'title': 'سورة الكهف - الآية 10', 'page': 'الصفحة 293'},
    {'title': 'سورة يس - الآية 58', 'page': 'الصفحة 443'},
  ];

  void _removeBookmark(int index) {
    setState(() {
      _bookmarks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف العلامة بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC4), // لون الخلفية التراثي
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A6B48),
        title: const Text(
          'الْعَلَامَاتُ الْمَحْفُوظَةُ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _bookmarks.isEmpty
          ? const Center(
              child: Text(
                'لا توجد علامات محفوظة حالياً',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A6B48),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = _bookmarks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EED9),
                    border: Border.all(color: const Color(0xFF5A6B48), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark, color: Color(0xFF5A6B48), size: 28),
                    title: Text(
                      bookmark['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    subtitle: Text(
                      bookmark['page']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5A6B48),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _removeBookmark(index),
                    ),
                    onTap: () {
                      // عند الضغط للانتقال إلى الآية المحفوظة
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('الانتقال إلى: ${bookmark['title']}')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
