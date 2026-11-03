import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuzTrackerScreen extends StatefulWidget {
  @override
  _JuzTrackerScreenState createState() => _JuzTrackerScreenState();
}

class _JuzTrackerScreenState extends State<JuzTrackerScreen> {
  List<bool> _juzStatus = List.generate(30, (index) => false);
  int _targetDays = 30; // عدد الأيام المستهدف

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < 30; i++) {
        _juzStatus[i] = prefs.getBool('juz_$i') ?? false;
      }
      _targetDays = prefs.getInt('target_days') ?? 30;
    });
  }

  Future<void> _saveProgress(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('juz_$index', value);
  }

  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _juzStatus = List.generate(30, (index) => false);
    });
    for (int i = 0; i < 30; i++) {
      await prefs.setBool('juz_$i', false);
    }
  }

  Future<void> _saveTargetDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('target_days', days);
    setState(() {
      _targetDays = days;
    });
  }

  void _showTargetDaysDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int tempDays = _targetDays;
        return AlertDialog(
          title: Text('حدد عدد أيام الختمة'),
          content: Container(
            width: double.minPositive,
            child: DropdownButtonFormField<int>(
              value: tempDays,
              items: List.generate(60, (index) => index + 1)
                  .map((days) => DropdownMenuItem(
                        value: days,
                        child: Text('$days يوم'),
                      ))
                  .toList(),
              onChanged: (value) {
                tempDays = value!;
              },
              decoration: InputDecoration(
                labelText: 'الأيام المستهدفة',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveTargetDays(tempDays);
                Navigator.pop(context);
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _juzStatus.where((completed) => completed).length;
    int remainingJuz = 30 - completedCount;
    double dailyRate = remainingJuz > 0 ? (_targetDays > 0 ? remainingJuz / _targetDays : 0) : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('تتبع أجزاء القرآن'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            tooltip: 'تغيير عدد الأيام',
            onPressed: _showTargetDaysDialog,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'إعادة ضبط الختمة',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('إعادة ضبط الختمة'),
                  content: Text('هل أنت متأكد من تصفير جميع الأجزاء؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        _resetProgress();
                        Navigator.pop(context);
                      },
                      child: Text('تأكيد', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.green[50],
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: completedCount / 30,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تم إنجاز: $completedCount / 30',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'المتبقي: $remainingJuz جزء',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insights, color: Colors.green[800], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'المعدل المقترح: ${dailyRate.toStringAsFixed(2)} جزء يومياً',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ],
                ),
                Text(
                  'خلال $_targetDays يوماً',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
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
                    _saveProgress(index, _juzStatus[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green[600] : Colors.white,
                      border: Border.all(
                        color: isCompleted ? Colors.green[700] : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'جزء ${index + 1}',
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
