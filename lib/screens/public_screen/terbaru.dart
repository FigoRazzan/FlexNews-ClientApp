import 'package:flutter/material.dart';
import 'package:flexnews/screens/webview_screen.dart';
import '../../services/api_service.dart';
import '../../services/db_helper.dart';

class TerbaruScreen extends StatefulWidget {
  final String media;
  final String category;

  TerbaruScreen({required this.media, required this.category});

  @override
  _TerbaruScreenState createState() => _TerbaruScreenState();
}

class _TerbaruScreenState extends State<TerbaruScreen> {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();

  String searchQuery = '';
  List<dynamic> allData = [];
  List<dynamic> filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.fetchPublicData(
        media: widget.media,
        category: widget.category,
      );

      final updatedData = await Future.wait(data.map((post) async {
        final likes = await dbHelper.getLikes(post['link']);
        final comments = await dbHelper.getComments(post['link']);

        return {
          ...post,
          'likes': likes,
          'comments': comments,
          'showAllComments': false,
        };
      }));

      setState(() {
        allData = updatedData;
        filteredData = updatedData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _filterData(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredData = allData;
      } else {
        filteredData = allData.where((post) {
          final title = post['title']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _likePost(int index) async {
    final post = filteredData[index];
    await dbHelper.incrementLike(post['link']);

    setState(() {
      filteredData[index]['likes'] = (filteredData[index]['likes'] ?? 0) + 1;
    });
  }

  void _showCommentsModal(int index) {
    TextEditingController commentController = TextEditingController();
    final post = filteredData[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            final comments = filteredData[index]['comments'];

            return FractionallySizedBox(
              heightFactor: 0.75,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Komentar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: comments.isEmpty
                        ? Center(child: Text('Belum ada komentar'))
                        : ListView.builder(
                            itemCount: filteredData[index]['showAllComments'] ==
                                    true
                                ? comments.length
                                : (comments.length > 5 ? 5 : comments.length),
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Anonymous',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            comments[i],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              commentController.text =
                                                  comments[i];
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Update Komentar'),
                                                    content: TextField(
                                                      controller:
                                                          commentController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Update komentar...',
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await dbHelper
                                                              .updateComment(
                                                            post['link'],
                                                            comments[i],
                                                            commentController
                                                                .text,
                                                          );

                                                          List<String>
                                                              updatedComments =
                                                              await dbHelper
                                                                  .getComments(
                                                                      post[
                                                                          'link']);

                                                          setState(() {
                                                            filteredData[index][
                                                                    'comments'] =
                                                                updatedComments;
                                                          });

                                                          Navigator.of(context)
                                                              .pop();
                                                          modalSetState(() {});
                                                        },
                                                        child: Text('Simpan'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              await dbHelper.deleteComment(
                                                post['link'],
                                                comments[i],
                                              );

                                              List<String> updatedComments =
                                                  await dbHelper.getComments(
                                                      post['link']);

                                              setState(() {
                                                filteredData[index]
                                                        ['comments'] =
                                                    updatedComments;
                                              });

                                              Navigator.of(context).pop();
                                              modalSetState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (comments.length > 5 &&
                      filteredData[index]['showAllComments'] == false)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          filteredData[index]['showAllComments'] = true;
                        });
                        modalSetState(() {});
                      },
                      child: Text('Lihat lebih banyak'),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 8,
                      right: 8,
                      top: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Tambahkan komentar...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            if (commentController.text.isNotEmpty) {
                              await dbHelper.addComment(
                                post['link'],
                                commentController.text,
                              );

                              List<String> updatedComments =
                                  await dbHelper.getComments(post['link']);

                              setState(() {
                                filteredData[index]['comments'] =
                                    updatedComments;
                              });

                              commentController.clear();
                              modalSetState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text('Berita: ${widget.media} / ${widget.category}'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: TextField(
                onChanged: _filterData,
                decoration: InputDecoration(
                  hintText: 'Cari berita...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),

            // News List
            Expanded(
              child: filteredData.isEmpty
                  ? Center(child: Text('Tidak ada berita yang ditemukan'))
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final post = filteredData[index];
                        final title = post['title'] ?? 'No Title';
                        final description =
                            post['description'] ?? 'No Description';
                        final imageUrl = post['thumbnail'] ?? '';
                        final link = post['link'] ?? '';
                        final likes = post['likes'];
                        final comments = post['comments'];

                        return GestureDetector(
                          onTap: () {
                            if (link.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen(url: link),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No link available')),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey[100]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/splash_screens_2.png',
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.thumb_up),
                                          onPressed: () => _likePost(index),
                                        ),
                                        Text('$likes Likes'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.comment),
                                          onPressed: () =>
                                              _showCommentsModal(index),
                                        ),
                                        Text('${comments.length} Comments'),
                                      ],
                                    ),
                                  ],
                                ),
                                if (comments.isNotEmpty) ...[
                                  Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        comments.take(5).map<Widget>((comment) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text('- $comment'),
                                      );
                                    }).toList(),
                                  ),
                                  if (comments.length > 5)
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          filteredData[index]
                                              ['showAllComments'] = true;
                                        });
                                      },
                                      child: Text('Lihat lebih banyak'),
                                    ),
                                ],
                              ],
                            ),
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
