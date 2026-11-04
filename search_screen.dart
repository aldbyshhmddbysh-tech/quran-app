import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // قائمة تجريبية لنتائج البحث (يمكن ربطها بقاعدة بيانات القرآن لاحقاً)
  final List> _allVerses = [
    {'surah': 'سورة الفاتحة', 'verse': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'number': 'الآية 1'},
    {'surah': 'سورة البقرة', 'verse': 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِلْمُتَّقِينَ', 'number': 'الآية 2'},
    {'surah': 'سورة البقرة', 'verse': 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ', 'number': 'الآية 255'},
    {'surah': 'سورة الكهف', 'verse': 'الْحَمْدُ لِلَّهِ الَّذِي أَنْزَلَ عَلَى عَبْدِهِ الْكِتَابَ وَلمْ يَجْعَلْ لَهُ عِوَجَا', 'number': 'الآية 1'},
    {'surah': 'سورة الإخلاص', 'verse': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'number': 'الآية 1'},
  ];

  List> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = _allVerses; // عرض الكل مبدئياً أو تركها فارغة حسب الرغبة
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _allVerses;
      } else {
        _searchResults = _allVerses.where((item) {
          return item['verse']!.contains(query) || item['surah']!.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC4), // لون الخلفية التراثي المتناسق
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A6B48),
        title: const Text(
          'الْبَحْثُ فِي الْقُرْآنِ الْكَرِيمِ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل البحث المزخرف
            Container(
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
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2C2C2C),
                ),
                decoration: const InputDecoration(
                  hintText: 'ابحث عن آية أو سورة...',
                  hintStyle: TextStyle(color: Color(0xFF8C8C8C)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF5A6B48)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // قائمة النتائج
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد نتائج مطابقة للبحث',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A6B48),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    result['surah']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5A6B48),
                                    ),
                                  ),
                                  Text(
                                    result['number']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6C6C6C),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Color(0xFF5A6B48), thickness: 0.5),
                              const SizedBox(height: 4),
                              Text(
                                result['verse']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
