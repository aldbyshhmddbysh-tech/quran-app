import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuzTrackerScreen extends StatefulWidget {
  @override
  _JuzTrackerScreenState createState() => _JuzTrackerScreenState();
}

class _JuzTrackerScreenState extends State<JuzTrackerScreen> {
  List<bool> _juzStatus = List.generate(30, (index) => false);

  @override
  void initState() {
    super.initState();
    _loadProgress(); // استرجاع البيانات المحفوظة عند فتح الشاشة
  }

  // تحميل الحالة المحفوظة من الذاكرة المحلية
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < 30; i++) {
        _juzStatus[i] = prefs.getBool('juz_$i') ?? false;
      }
    });
  }

  // حفظ حالة الجزء عند تغييره
  Future<void> _saveProgress(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('juz_$index', value);
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _juzStatus.where((completed) => completed).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('تتبع أجزاء القرآن'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: completedCount / 30,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          Text(
            'تم إنجاز: $completedCount من 30 جزءاً',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final isCompleted = _juzStatus[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _juzStatus[index] = !isCompleted;
                    });
                    _saveProgress(index, _juzStatus[index]); // الحفظ التلقائي
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green[600] : Colors.white,
                      border: Border.all(
                        color: isCompleted ? Colors.green[700] : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'جزء ${index + 1}',
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
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
