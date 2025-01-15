import 'package:flutter/material.dart';
import '../screens/public_screen/terbaru.dart';

class PublicDataScreen extends StatefulWidget {
  @override
  _PublicDataScreenState createState() => _PublicDataScreenState();
}

class _PublicDataScreenState extends State<PublicDataScreen> {
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

  String? selectedMedia;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Data'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Media:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedMedia,
                  hint: Text('Pilih Media'),
                  isExpanded: true,
                  items: mediaCategories.keys.map((media) {
                    return DropdownMenuItem(
                      value: media,
                      child: Text(media),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMedia = value;
                      selectedCategory =
                          null; // Reset kategori saat media berubah
                    });
                  },
                ),
                SizedBox(height: 16),
                if (selectedMedia != null) ...[
                  Text(
                    'Pilih Kategori:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text('Pilih Kategori'),
                    isExpanded: true,
                    items: mediaCategories[selectedMedia!]!.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (selectedMedia != null && selectedCategory != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TerbaruScreen(
                          media: selectedMedia!.toLowerCase(),
                          category: selectedCategory!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Pilih media dan kategori terlebih dahulu!'),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Lihat Data',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
