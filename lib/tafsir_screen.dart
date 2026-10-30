import 'package:flutter/material.dart';

class TafsirScreen extends StatelessWidget {
  final String ayahText;

  const TafsirScreen({Key? key, required this.ayahText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفسير الآية الكريمة'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة عرض الآية المراد تفسيرها
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
            
            // عنوان قسم التفسير
            const Text(
              'التفسير الميسر / الخلاصة:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            
            // نص التفسير
            Expanded(
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: const [
                      Text(
                        'هذه الآية الكريمة تحمل معاني عظيمة ومواعظ جليلة تتدبر فيها القلوب. (سيتم ربط النصوص التفصيلية الكاملة من كتب التفسير المعتمدة قريباً لتوفير مرجع علمي متكامل للمستخدمين).',
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
