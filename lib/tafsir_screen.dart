import 'package:flutter/material.dart';

class TafsirScreen extends StatelessWidget {
  final String ayahText;

  const TafsirScreen({Key? key, required this.ayahText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفسير العلامة محمد بن عبد الله عوض'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة عرض الآية الكريمة
            Card(
              elevation: 3,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  ayahText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // عنوان توضيحي للمرجع العلمي
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'الفوائد والتوجيهات التفسيرية:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.menu_book, size: 20, color: Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            
            // محتوى التفسير المستخلص
            Expanded(
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: const [
                      Text(
                        'من دروس وفوائد العلامة محمد بن عبد الله عوض:\n\n'
                        'هذه الآية الكريمة تدعو المؤمن إلى التدبر العميق والربط بين المعنى اللفظي والتطبيق العملي في واقع الحياة. وفي تقرير المعاني القرآنية، يؤكد فضيلته دائماً على أهمية استخلاص الهدايات والعبر التي تقوي اليقين وترسخ الإيمان في القلوب.\n\n'
                        '(سيتم ربط النصوص التفصيلية الكاملة من مجالس ودروس التفسير الخاصة بالشيخ لتكون مرجعاً متكاملاً في التطبيق).',
                        style: TextStyle(fontSize: 18, height: 1.8),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
