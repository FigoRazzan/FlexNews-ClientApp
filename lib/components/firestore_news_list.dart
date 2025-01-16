import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'news_card.dart';

class FirestoreNewsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('news')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Belum ada berita'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var newsData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return NewsCard(
              title: newsData['title'] ?? '',
              description: newsData['description'] ?? '',
              createdAt: newsData['created_at'] ?? '',
            );
          },
        );
      },
    );
  }
}
