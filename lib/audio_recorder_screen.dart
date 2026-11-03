import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({Key? key}) : super(key: key);

  @override
  State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;
  List<File> _recordedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadRecordedFiles();
  }

  // تحميل التسجيلات المحفوظة مسبقاً من ذاكرة التطبيق
  Future<void> _loadRecordedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final list = directory.listSync();
      setState(() {
        _recordedFiles = list
            .where((entity) => entity is File && entity.path.endsWith('.m4a'))
            .map((entity) => File(entity.path))
            .toList();
        // ترتيب التسجيلات من الأحدث للأقدم
        _recordedFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      });
    } catch (e) {
      print('Error loading files: $e');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );
        setState(() {
          _isRecording = true;
          _audioPath = filePath;
        });
      }
    } catch (e) {
      print('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });
      // إعادة تحميل القائمة لتحديث العناصر وإظهار التسجيل الجديد
      _loadRecordedFiles();
    } catch (e) {
      print('Error stopping record: $e');
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل التلاوات الصوتية'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // مؤشر حالة وأيقونة التسجيل
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red.withOpacity(0.1) : Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    size: 60,
                    color: _isRecording ? Colors.red : Colors.teal,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _isRecording ? 'جاري تسجيل التلاوة...' : 'جاهز للتسجيل الجديد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isRecording ? Colors.red : Colors.teal[800],
                  ),
                ),
                const SizedBox(height: 20),
                // زر البدء والإيقاف
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
                  label: Text(_isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
                  onPressed: () {
                    _isRecording ? _stopRecording() : _startRecording();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 40, thickness: 1.5, indent: 20, endIndent: 20),
          // عنوان قائمة التسجيلات السابقة
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'التسجيلات المحفوظة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // قائمة عرض الملفات الصوتية المسجلة
          Expanded(
            child: _recordedFiles.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد تسجيلات محفوظة حتى الآن',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _recordedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _recordedFiles[index];
                      final fileName = file.path.split('/').last;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.audio_file, color: Colors.teal),
                          title: Text(
                            fileName,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'المسار: ${file.path}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              if (await file.exists()) {
                                await file.delete();
                                _loadRecordedFiles();
                              }
                            },
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
