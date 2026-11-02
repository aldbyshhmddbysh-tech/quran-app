import 'package:flutter/material.dart';

class KhatmahScreen extends StatefulWidget {
  const KhatmahScreen({Key? key}) : super(key: key);

  @override
  _KhatmahScreenState createState() => _KhatmahScreenState();
}

class _KhatmahScreenState extends State<KhatmahScreen> {
  final TextEditingController _pagesController = TextEditingController();
  int _targetPages = 0;
  int _pagesRead = 0;
  double _progress = 0.0;

  void _calculateProgress() {
    setState(() {
      _targetPages = int.tryParse(_pagesController.text) ?? 0;
      if (_targetPages > 0) {
        _progress = (_pagesRead / _targetPages).clamp(0.0, 1.0);
      } else {
        _progress = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطة الختمة القرآنية'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _pagesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'أدخل عدد الصفحات المستهدف',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book, color: Colors.green),
                      ),
                      onChanged: (value) => _calculateProgress(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                      onPressed: () {
                        setState(() {
                          if (_pagesRead < _targetPages) {
                            _pagesRead++;
                            _calculateProgress();
                          }
                        });
                      },
                      child: const Text('تسجيل قراءة صفحة واحدة', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'تقدم الختمة: ${(_progress * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 16),
            Text('الصفحات المقروءة: $_pagesRead من $_targetPages'),
          ],
        ),
      ),
    );
  }
}
