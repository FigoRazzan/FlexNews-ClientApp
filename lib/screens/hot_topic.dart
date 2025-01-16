import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class HotTopicScreen extends StatefulWidget {
  @override
  _HotTopicScreenState createState() => _HotTopicScreenState();
}

class _HotTopicScreenState extends State<HotTopicScreen> {
  final ApiService _apiService = ApiService();
  Map<String, int> _themeCount = {};
  bool _isLoading = true;
  String _selectedMedia = 'Antara';

  final Map<String, List<String>> mediaCategories = {
    'Antara': [
      'terbaru',
      'politik',
      'hukum',
      'ekonomi',
      'bola',
      'olahraga',
      'humaniora',
      'lifestyle',
      'hiburan',
      'dunia',
      'tekno',
      'otomotif'
    ],
    'CNBC': [
      'terbaru',
      'investment',
      'news',
      'market',
      'entrepreneur',
      'syariah',
      'tech',
      'lifestyle',
      'opini',
      'profil'
    ],
    'CNN': [
      'terbaru',
      'nasional',
      'internasional',
      'ekonomi',
      'olahraga',
      'teknologi',
      'hiburan',
      'gayahidup'
    ],
    'JPNN': ['terbaru'],
    'Kumparan': ['terbaru'],
    'Merdeka': [
      'terbaru',
      'jakarta',
      'dunia',
      'gaya',
      'olahraga',
      'teknologi',
      'otomotif',
      'khas',
      'sehat',
      'jateng'
    ],
    'Okezone': [
      'terbaru',
      'celebrity',
      'sports',
      'otomotif',
      'economy',
      'techno',
      'lifestyle',
      'bola'
    ],
    'Republika': [
      'terbaru',
      'news',
      'daerah',
      'khazanah',
      'islam',
      'internasional',
      'bola',
      'leisure'
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchNewsForMedia(_selectedMedia);
  }

  Future<void> _fetchNewsForMedia(String media) async {
    setState(() {
      _isLoading = true;
      _themeCount.clear();
    });

    try {
      final categories = mediaCategories[media] ?? [];
      for (var category in categories) {
        try {
          final data = await _apiService.fetchPublicData(
            media: media.toLowerCase(),
            category: category,
          );
          setState(() {
            _themeCount[category] = (_themeCount[category] ?? 0) + data.length;
          });
        } catch (e) {
          print('Error fetching $media - $category: $e');
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<PieChartSectionData> _getSections() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.brown,
      Colors.lime,
    ];

    return _themeCount.entries.toList().asMap().entries.map((entry) {
      final int idx = entry.key;
      final MapEntry<String, int> themeEntry = entry.value;
      final double percentage = themeEntry.value /
          _themeCount.values.reduce((sum, value) => sum + value) *
          100;

      return PieChartSectionData(
        color: colors[idx % colors.length],
        value: themeEntry.value.toDouble(),
        title: percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: 150,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Hot Topics Chart'),
        backgroundColor: Colors.grey[200],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Dropdown untuk memilih media
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMedia,
                      isExpanded: true,
                      items: mediaCategories.keys.map((String media) {
                        return DropdownMenuItem<String>(
                          value: media,
                          child: Text(media),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedMedia = newValue;
                          });
                          _fetchNewsForMedia(newValue);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _themeCount.isEmpty
                          ? Center(child: Text('Tidak ada data tersedia'))
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: 400,
                                    padding: EdgeInsets.all(16),
                                    child: PieChart(
                                      PieChartData(
                                        sections: _getSections(),
                                        sectionsSpace: 2,
                                        centerSpaceRadius: 40,
                                        borderData: FlBorderData(show: false),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Wrap(
                                      spacing: 16.0,
                                      runSpacing: 8.0,
                                      children: _themeCount.entries
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final int idx = entry.key;
                                        final MapEntry<String, int> themeEntry =
                                            entry.value;
                                        final colors = [
                                          Colors.blue,
                                          Colors.red,
                                          Colors.green,
                                          Colors.orange,
                                          Colors.purple,
                                          Colors.teal,
                                          Colors.pink,
                                          Colors.amber,
                                          Colors.indigo,
                                          Colors.cyan,
                                          Colors.brown,
                                          Colors.lime,
                                        ];

                                        final double percentage = themeEntry
                                                .value /
                                            _themeCount.values.reduce(
                                                (sum, value) => sum + value) *
                                            100;

                                        return Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              36,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: colors[
                                                      idx % colors.length],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${themeEntry.key}\n${percentage.toStringAsFixed(1)}% (${themeEntry.value})',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
