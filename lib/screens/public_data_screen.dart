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
        title: Text('Public News'),
        backgroundColor: Colors.grey[200],
      ),
      backgroundColor: Colors.grey[200], // Background color for the scaffold
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Media:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMedia,
                      hint: Text('Pilih Media'),
                      isExpanded: true,
                      underline: Container(),
                      items: mediaCategories.keys.map((media) {
                        return DropdownMenuItem(
                          value: media,
                          child: Text(media),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMedia = value;
                          selectedCategory = null;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  if (selectedMedia != null) ...[
                    Text(
                      'Pilih Kategori:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        hint: Text('Pilih Kategori'),
                        isExpanded: true,
                        underline: Container(),
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
                    ),
                  ],
                ],
              ),
            ),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 2),
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
                        'Lihat Berita',
                        style: TextStyle(
                          color: Colors.black,
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
      ),
    );
  }
}
