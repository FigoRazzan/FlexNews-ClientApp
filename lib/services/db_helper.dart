// lib/services/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'news_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table for likes
    await db.execute('''
      CREATE TABLE likes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_link TEXT NOT NULL,
        likes_count INTEGER DEFAULT 0
      )
    ''');

    // Table for comments
    await db.execute('''
      CREATE TABLE comments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_link TEXT NOT NULL,
        comment_text TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Methods for likes
  Future<int> getLikes(String postLink) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'likes',
      where: 'post_link = ?',
      whereArgs: [postLink],
    );

    if (maps.isEmpty) {
      // If no record exists, create one with 0 likes
      await db.insert('likes', {
        'post_link': postLink,
        'likes_count': 0,
      });
      return 0;
    }

    return maps.first['likes_count'];
  }

  Future<void> incrementLike(String postLink) async {
    final db = await database;
    int currentLikes = await getLikes(postLink);

    await db.update(
      'likes',
      {'likes_count': currentLikes + 1},
      where: 'post_link = ?',
      whereArgs: [postLink],
    );
  }

  // Methods for comments
  Future<List<String>> getComments(String postLink) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'comments',
      where: 'post_link = ?',
      whereArgs: [postLink],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => maps[i]['comment_text'] as String);
  }

  Future<void> addComment(String postLink, String comment) async {
    final db = await database;
    await db.insert('comments', {
      'post_link': postLink,
      'comment_text': comment,
    });
  }

  Future<void> updateComment(
      String postLink, String oldComment, String newComment) async {
    final db = await database;
    await db.update(
      'comments',
      {'comment_text': newComment},
      where: 'post_link = ? AND comment_text = ?',
      whereArgs: [postLink, oldComment],
    );
  }

  Future<void> deleteComment(String postLink, String comment) async {
    final db = await database;
    await db.delete(
      'comments',
      where: 'post_link = ? AND comment_text = ?',
      whereArgs: [postLink, comment],
    );
  }
}
